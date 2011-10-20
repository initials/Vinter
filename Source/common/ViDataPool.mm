//
//  ViDataPool.mm
//  Vinter2D
//
//  Copyright 2011 by Nils Daumann and Sidney Just. All rights reserved.
//  Unauthorized use is punishable by torture, mutilation, and vivisection.
//

#include <zlib.h>
#import "ViDataPool.h"
#import "ViKernel.h"
#import "ViBase.h"

namespace vi
{
    namespace common
    {
        void dataPool::setAsset(vi::common::asset *asset, std::string const& name)
        {
            if(asset)
                asset->setName(&name);
            
            assets[name] = asset;
        }
        
        void dataPool::removeAsset(std::string const& name, bool deleteAsset)
        {
            if(deleteAsset)
            {
                vi::common::asset *asset = assets[name];
                delete asset;
            }
            
            assets[name] = NULL;
        }
        
        void dataPool::removeAllAssets(bool deleteAssets)
        {
            if(deleteAssets)
            {
                std::map<std::string, vi::common::asset *>::iterator iterator;
                for(iterator=assets.begin(); iterator!=assets.end(); iterator++)
                {
                    vi::common::asset *asset = (*iterator).second;
                    delete asset;
                }
            }
           
            assets.clear();
        }
        
        vi::common::asset *dataPool::assetForName(std::string const& name)
        {
            std::map<std::string, vi::common::asset *>::iterator iterator;
            iterator = assets.find(name);
            
            if(iterator == assets.end())
                return NULL;
            
            return (*iterator).second;
        }
        
        
        
        std::string dataPool::pathForFile(std::string const& _file)
        {
            std::string result;
            
            @autoreleasepool
            {
                NSString *file = [NSString stringWithUTF8String:_file.c_str()];
                NSString *name = [file stringByDeletingPathExtension];
                NSString *exte = [file pathExtension];
                NSString *path = nil;
                
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
                NSString *device = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? @"~iphone" : @"~ipad";
                NSString *scale = @"";
                
                if(vi::common::kernel::sharedKernel() && fabs(vi::common::kernel::sharedKernel()->scaleFactor - 2.0f) <= kViEpsilonFloat)
                    scale = @"@2x";
                
                if(!path)
                    path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@%@", name, scale, device] ofType:exte];
                
                if(!path)
                    path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@", name, device] ofType:exte];
                
                if(!path)
                    path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@", name, scale] ofType:exte];
#endif
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
                if(!path)
                    path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@", name, @"~mac"] ofType:exte];
#endif
                
                if(!path)
                    path = [[NSBundle mainBundle] pathForResource:name ofType:exte];
            
                result = std::string([path UTF8String]);
            }
            
            return result;
        }
        
        
        
        std::vector<uint8_t> dataPool::inflateMemory(std::vector<uint8_t> const& data)
        {
            size_t length = data.size();
            size_t halfLength = length / 2;
            
            std::vector<uint8_t> decompressed;
            decompressed.resize(length + halfLength);
            
            z_stream stream;
            stream.next_in = (Bytef *)&data[0];
            stream.avail_in = (uInt)length;
            stream.total_out = 0;
            stream.zalloc = Z_NULL;
            stream.zfree = Z_NULL;
            
            if(inflateInit2(&stream, 15 + 32) != Z_OK) 
                return decompressed;
            
            bool success = false;
            while(1)
            {
                if(stream.total_out >= decompressed.size())
                    decompressed.resize(decompressed.capacity() + halfLength);
                
                stream.next_out = &decompressed[stream.total_out];
                stream.avail_out = (uInt)(decompressed.size() - stream.total_out);
                
                int status = inflate(&stream, Z_SYNC_FLUSH);
                
                if(status == Z_STREAM_END) 
                {
                    success = true;
                    break;
                }
                
                if(status != Z_OK)
                {
                    ViLog(@"Failed to decompress data! Here be dragons!");
                    break;
                }
            }
            
            if(inflateEnd(&stream) != Z_OK) 
            {
                decompressed.clear();
                return decompressed;
            }
            
            if(success)
            {
                decompressed.resize(stream.total_out);
                return decompressed;
            }
            
            decompressed.clear();
            return decompressed;
        }
        
        std::vector<uint8_t> dataPool::base64decode(std::string const& base64String)
        {
            std::vector<uint8_t> result;
            
            if(base64String.length() > 0)
            {
                uint8_t character = '\0';
                uint8_t inbuf[4], outbuf[3];
                
                short ixinbuf = 0;
                bool atEnd = false;
                
                for(uint32_t i=0; i<base64String.length(); i++) 
                {
                    character = base64String[i];
                    
                    if((character >= 'A') && (character <= 'Z'))
                    {
                        character = character - 'A';
                    }
                    else if((character >= 'a') && (character <= 'z'))
                    {
                        character = character - 'a' + 26;
                    }
                    else if((character >= '0') && (character <= '9')) 
                    {
                        character = character - '0' + 52;
                    }
                    else if(character == '+') 
                    {
                        character = 62;
                    }
                    else if(character == '=') 
                    {
                        atEnd = true;
                    }
                    else if(character == '/') 
                    {
                        character = 63;
                    }
                    else 
                        continue;
                    
                    
                    short ctcharsinbuf = 3;                    
                    if(atEnd) 
                    {
                        if(!ixinbuf)
                            break;
                        
                        if((ixinbuf == 1) || (ixinbuf == 2)) 
                        {
                            ctcharsinbuf = 1;
                        }
                        else 
                            ctcharsinbuf = 2;
                        
                        ixinbuf = 3;
                    }
                    
                    inbuf[ixinbuf ++] = character;
                    if(ixinbuf == 4)
                    {
                        ixinbuf = 0;
                        
                        outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                        outbuf[1] = ((inbuf[1] & 0x0F) << 4 ) | ((inbuf[2] & 0x3C) >> 2 );
                        outbuf[2] = ((inbuf[2] & 0x03) << 6 ) | (inbuf[3] & 0x3F);
                        
                        for(short j=0; j<ctcharsinbuf; j++)
                            result.push_back(outbuf[j]);
                    }
                    
                    if(atEnd)  
                        break;
                }
            }
            
            return result;
        }
    }
}
