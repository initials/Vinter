//
//  ViXML.h
//  Vinter
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//
//  Inspired by the awesome TBXML project!

#include <string>
#import <Foundation/Foundation.h>
#import "ViBase.h"

#define ViXMLMaxElements    50
#define ViXMLMaxAttributes  50

namespace vi
{
    namespace common
    {
        class xmlParser;
        
        struct xmlAttribute;
        struct xmlElement
        {
            friend class xmlParser;
        public:           
            std::string name();
            std::string text();
            std::string valueOfAttributeNamed(std::string const& name);
            
            xmlElement *childNamed(std::string const& name);
            xmlElement *siblingNamed(std::string const& name);
            
        private:
            char *tname;
            char *ttext;
            
            xmlAttribute *firstAttribute;
            
            xmlElement *parentElement;
            
            xmlElement *firstChild;
            xmlElement *currentChild;
            
            xmlElement *nextSibling;
            xmlElement *previousSibling;
        };
        
        struct xmlElementBuffer;
        struct xmlAttributeBuffer;
        
        
        class xmlParser
        {
        public:
            xmlParser(NSURL *url);
            xmlParser(NSData *data);
            xmlParser(std::string const& name);
            ~xmlParser();
            
            xmlElement *getRootElement();
            
        private:
            void createFromBytes(char *data, long length);
            void parseXML();
            
            xmlElement *nextAvailableElement();
            xmlAttribute *nextAvailableAttribute();
            
            xmlElement *rootXMLElement;
            xmlElementBuffer    *currentElementBuffer;
            xmlAttributeBuffer  *currentAttributeBuffer;
            
            
            long currentElement;
            long currentAttribute;
            
            char *bytes;
            long length;
        };
    }
}
