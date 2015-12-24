
#import "MusicModel.h"
#import "Headers.h"
@implementation MusicModel


// 错误处理的方法
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //[super setValue:value forUndefinedKey:key];
    
    /*
    
    if ([key isEqualToString:@"MP3file"]) {
        
        AVFile *av1 =( AVFile *)value;
        
        self.MP3file_url = [av1 valueForKey:@"url"];
        NSLog(@"        self.MP3file_url=%@",self.MP3file_url);
    }
    
    if ([key isEqualToString:@"blurpicfile"]) {
        
        
        AVFile *av2 =( AVFile *)value;
        
        
        self.blurpicfile_url =[av2 valueForKey:@"url"];
    }
    
    if ([key isEqualToString:@"picfile"]) {
        
        
        
        AVFile *av3 =( AVFile *)value;
        self.picfile_url = [av3 valueForKey:@"url"];
    }
    */
    
    
}








@end
