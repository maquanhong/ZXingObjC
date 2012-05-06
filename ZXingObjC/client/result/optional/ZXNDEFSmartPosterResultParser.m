#import "ZXNDEFRecord.h"
#import "ZXNDEFSmartPosterParsedResult.h"
#import "ZXNDEFSmartPosterResultParser.h"
#import "ZXNDEFTextResultParser.h"
#import "ZXNDEFURIResultParser.h"
#import "ZXResult.h"

@implementation ZXNDEFSmartPosterResultParser

+ (ZXNDEFSmartPosterParsedResult *)parse:(ZXResult *)result {
  unsigned char * bytes = [result rawBytes];
  if (bytes == nil) {
    return nil;
  }
  ZXNDEFRecord * headerRecord = [ZXNDEFRecord readRecord:bytes offset:0];
  if (headerRecord == nil || ![headerRecord messageBegin] || ![headerRecord messageEnd]) {
    return nil;
  }
  if (![[headerRecord type] isEqualToString:SMART_POSTER_WELL_KNOWN_TYPE]) {
    return nil;
  }

  int offset = 0;
  int recordNumber = 0;
  ZXNDEFRecord * ndefRecord = nil;
  unsigned char * payload = [headerRecord payload];
  int action = ACTION_UNSPECIFIED;
  NSString * title = nil;
  NSString * uri = nil;

  while (offset < [headerRecord payloadLength] && (ndefRecord = [ZXNDEFRecord readRecord:payload offset:offset]) != nil) {
    if (recordNumber == 0 && ![ndefRecord messageBegin]) {
      return nil;
    }

    NSString * type = [ndefRecord type];
    if ([TEXT_WELL_KNOWN_TYPE isEqualToString:type]) {
      NSArray * languageText = [ZXNDEFTextResultParser decodeTextPayload:[ndefRecord payload] length:[ndefRecord payloadLength]];
      title = [languageText objectAtIndex:1];
    } else if ([URI_WELL_KNOWN_TYPE isEqualToString:type]) {
      uri = [ZXNDEFURIResultParser decodeURIPayload:[ndefRecord payload] length:[ndefRecord payloadLength]];
    } else if ([ACTION_WELL_KNOWN_TYPE isEqualToString:type]) {
      action = [ndefRecord payload][0];
    }
    recordNumber++;
    offset += [ndefRecord totalRecordLength];
  }

  if (recordNumber == 0 || (ndefRecord != nil && ![ndefRecord messageEnd])) {
    return nil;
  }

  return [[[ZXNDEFSmartPosterParsedResult alloc] initWithAction:action uri:uri title:title] autorelease];
}

@end
