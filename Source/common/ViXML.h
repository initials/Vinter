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
        
        /**
         * @brief Represenation of an XML element
         *
         * The class wraps the content of an XML element, this is the attributes, childs, data etc.
         **/
        struct xmlElement
        {
            friend class xmlParser;
        public:           
            /**
             * Returns the name of the XML element
             **/
            std::string name();
            /**
             * Returns the text data of the XML element
             **/
            std::string text();
            /**
             * Returns the value of the attribute with the given name, or an empty string if no attribute with a matching name was found.
             **/
            std::string valueOfAttributeNamed(std::string const& name);
            
            /**
             * Returns the first child with the given name, or NULL.
             **/
            xmlElement *childNamed(std::string const& name);
            /**
             * Returns the child next to this element with the given name, or NULL.
             **/
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
        
        
        /**
         * @brief Represents a DOM XML parser
         *
         * A xmlParser can read from a file or URL and parse the contained XML, the parsing is based on the great TBXML XML parser and thus the parser
         * is a DOM parser, meaning that the whole data is loaded into memory! You don't have to explicitly tell the parser to parse but you just create
         * a new instance instead which automatically parses the passed XML file/data.
         **/
        class xmlParser
        {
        public:
            /**
             * Constructor.
             * @param url A file URL.
             **/
            xmlParser(NSURL *url);
            /**
             * Constructor.
             * @param data Data containing the XML file
             **/
            xmlParser(NSData *data);
            /**
             * Constructor.
             * @param name The name of the XML file.
             * @sa vi::common::dataPool::pathForFile()
             **/
            xmlParser(std::string const& name);
            /**
             * Destructor.
             **/
            ~xmlParser();
            
            /**
             * Returns the root element.
             **/
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
