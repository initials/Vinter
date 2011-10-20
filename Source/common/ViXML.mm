//
//  ViXML.mm
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//
//  Inspired by the awesome TBXML project!

#include <cstring>
#include <stdlib.h>
#import "ViXML.h"
#import "ViDataPool.h"

#define ViXMLAttributeNameStart     0
#define ViXMLAttributeNameEnd       1
#define ViXMLAttributeValueStart    2
#define ViXMLAttributeValueEnd      3
#define ViXMLAttributeCDATAEnd      4

namespace vi
{
    namespace common
    {
        struct xmlAttribute
        {
            char *name;
            char *value;
            struct xmlAttribute *next;
        };
        
        struct xmlElementBuffer
        {
            xmlElement *elements;
            struct xmlElementBuffer *next;
            struct xmlElementBuffer *previous;
        };
        
        struct xmlAttributeBuffer 
        {
            xmlAttribute *attributes;
            struct xmlAttributeBuffer *next;
            struct xmlAttributeBuffer *previous;
        };

            
        
        xmlParser::xmlParser(NSURL *url)
        {
            NSData *data = [[NSData alloc] initWithContentsOfURL:url];
            createFromBytes((char *)[data bytes], [data length]);
        }
        
        xmlParser::xmlParser(NSData *data)
        {
            createFromBytes((char *)[data bytes], [data length]);
        }
        
        xmlParser::xmlParser(std::string const& name)
        {
            std::string path = vi::common::dataPool::pathForFile(name);
            
            NSData *data = [[NSData alloc] initWithContentsOfFile:[NSString stringWithUTF8String:path.c_str()]];
            createFromBytes((char *)[data bytes], [data length]);
        }
        
        xmlParser::~xmlParser()
        {
            if(bytes)
                free(bytes);
            
            while(currentElementBuffer)
            {
                if (currentElementBuffer->elements)
                    free(currentElementBuffer->elements);
                
                if(currentElementBuffer->previous)
                {
                    currentElementBuffer = currentElementBuffer->previous;
                    free(currentElementBuffer->next);
                } 
                else 
                {
                    free(currentElementBuffer);
                    currentElementBuffer = NULL;
                }
            }
            
            while(currentAttributeBuffer)
            {
                if(currentAttributeBuffer->attributes)
                    free(currentAttributeBuffer->attributes);
                
                if(currentAttributeBuffer->previous)
                {
                    currentAttributeBuffer = currentAttributeBuffer->previous;
                    free(currentAttributeBuffer->next);
                } 
                else
                {
                    free(currentAttributeBuffer);
                    currentAttributeBuffer = NULL;
                }
            }
        }
        
        xmlElement *xmlParser::getRootElement()
        {
            return rootXMLElement;
        }
        
        
        
        void xmlParser::createFromBytes(char *data, long dataLength)
        {
            rootXMLElement = NULL;
            
            currentElementBuffer = NULL;
            currentAttributeBuffer = NULL;
            
            currentElement   = 0;
            currentAttribute = 0;		
            
            bytes = (char *)malloc(dataLength + 1);
            length = dataLength;
            
            memcpy(bytes, data, length);
            bytes[length] = '\0';
            
            if(bytes)
                parseXML();
        }
        
        xmlElement *xmlParser::nextAvailableElement()
        {
            currentElement ++;
            
            if(!currentElementBuffer) 
            {
                currentElementBuffer = (xmlElementBuffer *)calloc(1, sizeof(xmlElementBuffer));
                currentElementBuffer->elements = (xmlElement *)calloc(ViXMLMaxElements, sizeof(xmlElement));
                currentElement = 0;
                rootXMLElement = &currentElementBuffer->elements[currentElement];
            } 
            else if(currentElement >= ViXMLMaxElements) 
            {
                currentElementBuffer->next = (xmlElementBuffer *)calloc(1, sizeof(xmlElementBuffer));
                currentElementBuffer->next->previous = currentElementBuffer;
                currentElementBuffer = currentElementBuffer->next;
                currentElementBuffer->elements = (xmlElement *)calloc(ViXMLMaxElements, sizeof(xmlElement));
                currentElement = 0;
            }
            
            return &currentElementBuffer->elements[currentElement];
        }
        
        xmlAttribute *xmlParser::nextAvailableAttribute()
        {
            currentAttribute ++;
            
            if(!currentAttributeBuffer) 
            {
                currentAttributeBuffer = (xmlAttributeBuffer *)calloc(1, sizeof(xmlAttributeBuffer));
                currentAttributeBuffer->attributes = (xmlAttribute *)calloc(ViXMLMaxAttributes, sizeof(xmlAttribute));
                currentAttribute = 0;
            } 
            else if (currentAttribute >= ViXMLMaxAttributes) 
            {
                currentAttributeBuffer->next = (xmlAttributeBuffer *)calloc(1, sizeof(xmlAttributeBuffer));
                currentAttributeBuffer->next->previous = currentAttributeBuffer;
                currentAttributeBuffer = currentAttributeBuffer->next;
                currentAttributeBuffer->attributes = (xmlAttribute *)calloc(ViXMLMaxAttributes, sizeof(xmlAttribute));
                currentAttribute = 0;
            }
            
            return &currentAttributeBuffer->attributes[currentAttribute];
        }
        
        
        void xmlParser::parseXML()
        {
            char *elementStart = bytes;
            xmlElement *parentElement = NULL;
            
             while((elementStart = strstr(elementStart, "<")))
             {
                 // Comments
                 if(strncmp(elementStart,"<!--", 4) == 0)
                 {
                     elementStart = strstr(elementStart, "-->") + 3;
                     continue;
                 }
                 
                 bool isCDATA = (strncmp(elementStart, "<![CDATA[", 9) == 0);
                 if(isCDATA)
                 {
                     char *CDATAEnd = strstr(elementStart, "]]>");
                     char *elementEnd = CDATAEnd;
                     
                     elementEnd = strstr(elementEnd, "<");
                     
                     while(strncmp(elementEnd, "<![CDATA[", 9) == 0) 
                     {
                         elementEnd = strstr(elementEnd, "]]>");
                         elementEnd = strstr(elementEnd, "<");
                     }
                     
                     long CDATALength = (long)(CDATAEnd - elementStart);
                     long textLength  = (long)(elementEnd - elementStart);
                     
                     memcpy(elementStart, elementStart + 9, CDATAEnd - elementStart - 9);
                     memcpy(CDATAEnd - 9, CDATAEnd + 3, textLength - CDATALength - 3);
                     memset(elementStart+textLength - 12, ' ', 12);
                      
                     elementStart = CDATAEnd - 9;
                     continue;
                 }
                 
                 
                 char *elementEnd = elementStart + 1;		
                 while((elementEnd = strpbrk(elementEnd, "<>"))) 
                 {
                     if(strncmp(elementEnd, "<![CDATA[", 9) == 0) 
                     {
                         elementEnd = strstr(elementEnd, "]]>") + 3;
                     } 
                     else 
                         break;
                 }
                 
                 if(elementEnd) 
                     *elementEnd = 0;
    
                 *elementStart = 0;
                 
                 char *elementNameStart = elementStart + 1;
                 if(*elementNameStart == '?' || (*elementNameStart == '!' && !isCDATA)) 
                 {
                     elementStart = elementEnd + 1;
                     continue;
                 }
                 
                 if(*elementNameStart == '/') 
                 {
                     elementStart = elementEnd + 1;
                     if(parentElement) 
                     {
                         if(parentElement->ttext) 
                         {
                             while(isspace(*parentElement->ttext)) 
                                 parentElement->ttext ++;
                             
                             char *end = parentElement->ttext + strlen(parentElement->ttext)-1;
                             while(end > parentElement->ttext && isspace(*end)) 
                                 *end-- = 0;
                         }
                         
                         parentElement = parentElement->parentElement;
                         if(parentElement && parentElement->firstChild)
                             parentElement->ttext = NULL;
                     }
                     
                     continue;
                 }
                 
                 
                 bool selfClosingElement = (*(elementEnd - 1) == '/');
                 
                 xmlElement *element = nextAvailableElement();
                 element->tname = elementNameStart;
                 
                 if(parentElement)
                 {
                     if(parentElement->currentChild) 
                     {
                         parentElement->currentChild->nextSibling = element;
                         element->previousSibling = parentElement->currentChild;
                         
                         parentElement->currentChild = element;
                     } 
                     else 
                     {
                         parentElement->currentChild = element;
                         parentElement->firstChild = element;
                     }
                     
                     element->parentElement = parentElement;
                 }
                 
                 
                 char *elementNameEnd = strpbrk(element->tname, " /");
                 if(elementNameEnd)
                 {
                     *elementNameEnd = '\0';
                     
                     char *chr = elementNameEnd;
                     char *name = NULL;
                     char *value = NULL;
                     char *CDATAStart = NULL;
                     char *CDATAEnd = NULL;
                     xmlAttribute *lastAttribute = NULL;
                     xmlAttribute *attribute = NULL;
                     bool singleQuote = false;
                     
                     
                     int state = ViXMLAttributeNameStart;
                     while(chr++ < elementEnd)
                     {
                         switch(state) 
                         {
                             case ViXMLAttributeNameStart:
                                 if(isspace(*chr)) 
                                     continue;
                                 
                                 name  = chr;
                                 state = ViXMLAttributeNameEnd;
                                 break;
        
                             case ViXMLAttributeNameEnd:
                                 if(isspace(*chr) || *chr == '=') 
                                 {
                                     *chr  = 0;
                                     state = ViXMLAttributeValueStart;
                                 }
                                 break;

                             case ViXMLAttributeValueStart:
                                 if(isspace(*chr)) 
                                     continue;
                                 
                                 if(*chr == '"' || *chr == '\'') 
                                 {
                                     value = chr + 1;
                                     state = ViXMLAttributeValueEnd;
                                     singleQuote = (*chr == '\'');
                                 }
                                 break;

                             case ViXMLAttributeValueEnd:
                                 if(*chr == '<' && strncmp(chr, "<![CDATA[", 9) == 0)
                                 {
                                     state = ViXMLAttributeCDATAEnd;
                                 }
                                 else if((*chr == '"' && !singleQuote) || (*chr == '\'' && singleQuote)) 
                                 {
                                     *chr = 0;
                                     
                                     while((CDATAStart = strstr(value, "<![CDATA[")))
                                     {
                                         memcpy(CDATAStart, CDATAStart + 9, strlen(CDATAStart) - 8);
                                         
                                         CDATAEnd = strstr(CDATAStart,"]]>");
                                         
                                         memcpy(CDATAEnd, CDATAEnd + 3, strlen(CDATAEnd) - 2);
                                     }
                                     
                                     
                                     attribute = nextAvailableAttribute();
                                     
                                     if(!element->firstAttribute)
                                         element->firstAttribute = attribute;
                                     
                                     if(lastAttribute) 
                                         lastAttribute->next = attribute;
                                     
                                     lastAttribute = attribute;
                                     
                                     attribute->name = name;
                                     attribute->value = value;
                                     
                                     name  = NULL;
                                     value = NULL;
                                     
                                     state = ViXMLAttributeNameStart;
                                 }
                                 break;

                             case ViXMLAttributeCDATAEnd:
                                 if(*chr == ']' && (strncmp(chr, "]]>", 3) == 0)) 
                                 {
                                     state = ViXMLAttributeValueEnd;
                                 }
                                 break;	
                                 
                             default:
                                 break;
                         }
                     }
                 }
                 
                 if(!selfClosingElement) 
                 {
                     if(*(elementEnd + 1) != '>')
                         element->ttext = elementEnd + 1;
                     
                     parentElement = element;
                 }
                 
                 elementStart = elementEnd+1;
             }
        }
        
        
        std::string xmlElement::name()
        {
            return std::string(tname);
        }
        
        std::string xmlElement::text()
        {
            if(!ttext)
                return std::string();
                
            return std::string(ttext);
        }
        
        std::string xmlElement::valueOfAttributeNamed(std::string const& attributeName)
        {
            std::string value;
            xmlAttribute *attribute = firstAttribute;
            while(attribute)
            {
                if(attributeName.compare(attribute->name) == 0)
                {
                    value = std::string(attribute->value);
                    break;
                }
                
                attribute = attribute->next;
            }
            
            return value;
        }        
        
        xmlElement *xmlElement::childNamed(std::string const& tname)
        {
            xmlElement *element = firstChild;
            while(element)
            {
                if(tname.compare(element->name()) == 0)
                {
                    return element;
                }
                
                element = element->nextSibling;
            }
            
            return NULL;
        }
        
        xmlElement *xmlElement::siblingNamed(std::string const& tname)
        {           
            xmlElement *element = nextSibling;
            while(element)
            {
                if(tname.compare(element->name()) == 0)
                {
                    return element;
                }
                
                element = element->nextSibling;
            }
            
            return NULL;
        }
    }
}
