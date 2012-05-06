/**
 * Abstract class representing the result of decoding a barcode, as more than
 * a String -- as some type of structured data. This might be a subclass which represents
 * a URL, or an e-mail address. parseResult() will turn a raw
 * decoded string into the most appropriate type of structured representation.
 * 
 * Thanks to Jeff Griffin for proposing rewrite of these classes that relies less
 * on exception-based mechanisms during parsing.
 */

@class ZXParsedResult, ZXResult;

@interface ZXResultParser : NSObject

+ (ZXParsedResult *)parseResult:(ZXResult *)theResult;
+ (void)maybeAppend:(NSString *)value result:(NSMutableString *)result;
+ (void)maybeAppendArray:(NSArray *)value result:(NSMutableString *)result;
+ (NSArray *)maybeWrap:(NSString *)value;
+ (NSString *)unescapeBackslash:(NSString *)escaped;
+ (BOOL)isStringOfDigits:(NSString *)value length:(unsigned int)length;
+ (BOOL)isSubstringOfDigits:(NSString *)value offset:(int)offset length:(unsigned int)length;
+ (NSMutableDictionary *)parseNameValuePairs:(NSString *)uri;
+ (NSArray *)matchPrefixedField:(NSString *)prefix rawText:(NSString *)rawText endChar:(unichar)endChar trim:(BOOL)trim;
+ (NSString *)matchSinglePrefixedField:(NSString *)prefix rawText:(NSString *)rawText endChar:(unichar)endChar trim:(BOOL)trim;

@end
