//
//  MusicDataHandle.m
//  MusicPlay1102
//
//  Created by 李宁 on 15/11/3.
//  Copyright © 2015年 lining. All rights reserved.
//
#import "Headers.h"
#import "MusicDataHandle.h"
static MusicDataHandle *musicHandle=nil;
@interface MusicDataHandle()<NSURLSessionDataDelegate,NSURLSessionDownloadDelegate>
@property(nonatomic,strong)NSMutableArray *musicArray;


@property(nonatomic,copy)NSString *dbPath;//数据库的路径
@property(nonatomic,copy)NSString *filesPath;//存放从数据库获取的文件的文件夹
@property(nonatomic,copy)NSString *projectPath;//沙盒文件夹路径



@property(nonatomic,strong)NSURLRequest *request;
@property(nonatomic,strong)NSURLSession *session;
@property(nonatomic,strong)NSURLSessionDownloadTask *task;

@property(nonatomic,strong)MusicModel *currModel;

@property(assign,nonatomic) BOOL Error;
@property(nonatomic,strong)NSData *data_mp3;

@property(nonatomic,strong)NSData *data_pic;

@property(nonatomic,strong)NSData *data_blurpic;
@property(nonatomic,assign)NSInteger songNum;
@end

@implementation MusicDataHandle

-(NSString*)filesPath{
    
    if (_filesPath==nil) {
        NSString * cachesPath=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        
        //创建一个新文件夹存放从数据库获得的数据
        NSString *s=[NSString stringWithFormat:@"/%@fileFromNet",[self getNowDate]];
        self.filesPath =[cachesPath stringByAppendingPathComponent:s];
        NSFileManager *m=[NSFileManager defaultManager];//单例
        [m createDirectoryAtPath:self.filesPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return _filesPath;
    
    
}
-(NSString *)projectPath{
    if (_projectPath==nil) {
        
        NSString * documents=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        
        self.projectPath = [documents substringWithRange:NSMakeRange(0, [documents length] - 10)];//    /documents->正好10个字符
        
        
    }
    return _projectPath;
}
-(void)getMusicData_2LC{
    
    NSString *string = @"http://project.lanou3g.com/teacher/UIAPI/MusicInfoList.plist";
    
    NSURL *url = [NSURL URLWithString:string];
    
    NSArray *array = [NSArray arrayWithContentsOfURL:url];
    //NSLog(@"array=%@",array);
    
    for (NSDictionary *dic in array) {
        MusicModel *m = [[MusicModel alloc]init];
        [m setValuesForKeysWithDictionary:dic];
        [self.musicArray addObject:m];
        NSLog(@"m.singer=%@",m.singer);
        
        NSLog(@"m.name=%@",m.name);
        
        
    }
    
    
    
    
}

-(void)getMusicDataFromLC{

    
    
    
    
    
    AVQuery *query = [AVQuery queryWithClassName:@"musicAtLC"];
    //[query whereKey:@"name" equalTo:@"失忆"];
    query.limit = 5; // 最多返回 800 条结果
    
    // 按发帖时间升序排列
    [query orderByAscending:@"createdAt"];
    
    // 按发帖时间降序排列
    //[query orderByDescending:@"createdAt"];
    
    
  NSArray *arr =  [query findObjects];
    
   // NSLog(@"arr=%@",arr);
    if (arr) {
        // 检索成功
        
        for (AVObject *dic in arr) {
         //    NSLog(@"dic=%@",dic);
            
            
            MusicModel *m = [[MusicModel alloc]init];
            
            NSString *oID = [dic objectForKey:@"objectId"];
            NSDictionary *ddic =[dic objectForKey:@"localData"];
           // NSLog(@"ddic=%@",ddic);
            [m setValuesForKeysWithDictionary:ddic];
            
            [self.musicArray addObject:m];
            
            
            //更新lc数据代码
            /*
            // 知道 objectId，创建 AVObject
            AVObject *post = [AVObject objectWithoutDataWithClassName:@"musicAtLC" objectId:oID];
            //更新属性
        [post setObject:m.picfile_url forKey:@"picfile_url"];
            
            [post setObject:m.MP3file_url forKey:@"MP3file_url"];
            
            [post setObject:m.blurpicfile_url forKey:@"blurpicfile_url"];
            //保存
            if ([post save]) {
                NSLog(@"%@更新成功",m.name);
            }
            else {
                 NSLog(@"%@更新失败",m.name);
            }
            
            */
            
            
        }
        
    } else {
        // 输出错误信息
       // NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
    
    
    
    
    
    /*
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // 检索成功
            NSLog(@"Successfully retrieved %lu posts.", (unsigned long)objects.count);
          // NSLog(@"objects=%@",objects);
            
            for (AVObject *dic in objects) {
                
                
                
                MusicModel *m = [[MusicModel alloc]init];
                
                
                NSDictionary *ddic =[dic objectForKey:@"localData"];
                
                [m setValuesForKeysWithDictionary:ddic];
                
                [self.musicArray addObject:m];
            }
            
        } else {
            // 输出错误信息
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    */
    
    



}
-(void)getMusicData{
    
        NSString *string = @"http://project.lanou3g.com/teacher/UIAPI/MusicInfoList.plist";
    
        NSURL *url = [NSURL URLWithString:string];
        
        NSArray *array = [NSArray arrayWithContentsOfURL:url];
        //NSLog(@"array=%@",array);
    NSLog(@"共有%lu首歌曲",(unsigned long)array.count);
    self.songNum=array.count;
    
        for (NSDictionary *dic in array) {
            MusicModel *m = [[MusicModel alloc]init];
            [m setValuesForKeysWithDictionary:dic];
            [self.musicArray addObject:m];
           
            
        }// for (NSDictionary *dic in array)

   
    
    
            
            
}
//从网址下载音乐
+(instancetype)shareMusicDataHandleWithFinishBlock:(finishBlock)finishblock{
    if (musicHandle==nil) {
        musicHandle =[[MusicDataHandle alloc]init];
        musicHandle.musicArray =[NSMutableArray array];

        //开辟一个子线程
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            
           [musicHandle getMusicDataFromLC];
            
            
            finishblock();
            
            
            
            
        });//开辟一个子线程
    }
    return musicHandle;
}
-(NSInteger)musicDataCount{
    return self.musicArray.count;
}
-(MusicModel *)musicWithIndex:(NSInteger)index{
    return self.musicArray[index];
}



//获取桌面路径
-(NSString*)getDesktopPath{
    NSString * documents=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    // NSLog(@"documents=%@",documents);
    
    
    
    NSString *s_date=[self getNowDate];
    NSArray * arr =[documents componentsSeparatedByString:@"/"];
    // NSLog(@"arr=%@",arr);
    
    
    
    NSString *s=[NSString stringWithFormat:@"/%@/%@/Desktop/%@程序文件夹",arr[1],arr[2],s_date];
    return s;
}


//获取当前日期
-(NSString *)getNowDate{
    NSDate *date = [NSDate date];
    
    // NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    //NSInteger interval = [zone secondsFromGMTForDate: date];
    
    // NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    // NSLog(@"localeDate=%@", destDateString);
    return destDateString;
}


-(void)copyToDesktop{
    NSLog(@"将文件夹移动到桌面");
    
    NSFileManager *m=[NSFileManager defaultManager];//单例
    
    //将程序沙盒文件夹拷贝到桌面
    [m copyItemAtPath:self.projectPath toPath:[self getDesktopPath] error:nil];
    
    
   // [m removeItemAtPath:self.filesPath error:nil];//删除沙盒中下载的文件
   // [m removeItemAtPath:self.dbPath error:nil];//删除沙盒中数据库文件
    
    
    
    NSString * documents=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSLog(@"沙盒文件夹路径=%@",documents);
}

#pragma mark --下载
-(void)downloadmp3:(NSString *)url{
     NSURL *uurl = [NSURL URLWithString:url];
    
    
    //创建请求对象  默认是get请求
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:uurl];
    //创建响应对象
    NSURLResponse * response=nil;
    //错误
    NSError *error=nil;
    //建立连接，传输数据
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //打印响应
    NSLog(@"response=%@",response);
    
    //解析时候，data为空，就会崩溃
    if (data!=nil)
    {
        /*
        
        NSString  *filemp3=  [self.filesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@平凡之路-片段.mp3",[self getNowDate]]];
        [data writeToFile:filemp3 atomically:YES];
        */
        self.data_mp3=data;
        
    }
    else {
        NSLog(@"获取MP3数据失败。");
    
        self.Error=YES;
    }
    
    

}
-(void)downloadpic:(NSString *)url{
    NSURL *uurl = [NSURL URLWithString:url];
    
    
    //创建请求对象  默认是get请求
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:uurl];
    //创建响应对象
    NSURLResponse * response=nil;
    //错误
    NSError *error=nil;
    //建立连接，传输数据
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //打印响应
    NSLog(@"response=%@",response);
    
    //解析时候，data为空，就会崩溃
    if (data!=nil)
    {
        /*
        
        NSString  *filePic=  [self.filesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@芦田爱菜.jpg",[self getNowDate]]];
        
        [data writeToFile:filePic atomically:YES];
        */
        self.data_pic=data;
        
    }
    else  {
        NSLog(@"获取pic数据失败。");
        
        self.Error=YES;
    }
}
-(void)downloadblurpic:(NSString *)url{
    
    NSURL *uurl = [NSURL URLWithString:url];
    
    
    //创建请求对象  默认是get请求
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:uurl];
    //创建响应对象
    NSURLResponse * response=nil;
    //错误
    NSError *error=nil;
    //建立连接，传输数据
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //打印响应
    NSLog(@"response=%@",response);
    
    //解析时候，data为空，就会崩溃
    if (data!=nil)
    {
        
        /*
        NSString  *filePic=  [self.filesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@芦田爱菜blur.jpg",[self getNowDate]]];
        
        [data writeToFile:filePic atomically:YES];
        */
        self.data_blurpic = data;
        
    }
    else
    {
        NSLog(@"获取blurpic数据失败。");
        
        self.Error=YES;
    }
    
}



-(void)startDownload:(NSString*)url
{
    NSURL *uurl = [NSURL URLWithString:url];
    
    /*
    self.request=[NSURLRequest requestWithURL:uurl];
    NSURLSessionConfiguration *conf =[NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:conf delegate:self delegateQueue:nil];
    
    
    self.task = [self.session downloadTaskWithRequest:self.request];
    
    [self.task resume];
    
    */
    
    
    
}
//下载完成
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
    NSLog(@"下载完成");
    NSLog(@"location=%@",location);
    NSData *data =[NSData dataWithContentsOfURL:location];
   
    
    NSString  *filemp3=  [self.filesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@平凡之路-片段.mp3",[self getNowDate]]];
    [data writeToFile:filemp3 atomically:YES];
    
}
//下载多少
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    
    
    
}
//下载进度下载总量---进度--文件大小
//BytesWritten--当前写入文件的大小
//totalBytesWritten--已经写入文件的大小
//totalBytesExpectedToWrite--文件总大小
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
  //  NSLog(@"正在下载。");
   // NSLog(@"bytesWritten=%lld",bytesWritten/1024);
  //  NSLog(@"totalBytesExpectedToWrite=%lld",totalBytesExpectedToWrite/1024);
    
    //self.myPro.progress = bytesWritten/totalBytesExpectedToWrite ;
    
    //[self.myPro setProgress:bytesWritten/totalBytesExpectedToWrite animated:YES];
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.myPro.progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
//        
//    });
    
    
    
}


#pragma mark --leancloud


-(BOOL)haveThisMp3:(MusicModel*)m
{
    
    
    AVQuery *query = [AVQuery queryWithClassName:@"musicAtLC"];
    [query whereKey:@"name" equalTo:m.name];
    NSArray *postArray = [query findObjects];
    if (postArray.count>0) {
       return YES;
    }
   else return NO;
    
}
-(BOOL)savetoLC:(MusicModel*)m
{
    
    
    AVObject *post = [AVObject objectWithClassName:@"musicAtLC"];
    //歌曲名字
    post[@"name"] =m.name;
    //album名字
    post[@"album"] = m.album;
    //演唱者
    post[@"singer"] = m.singer;//
    
    
    //原唱
    post[@"artists_name"] = m.artists_name;
    //lyric歌词
    post[@"lyric"] = m.lyric;
    
    //duration 长度 多少毫秒
    post[@"duration"] = m.duration;
    
    //mp3Url
    
    post[@"mp3Url"] = m.mp3Url;
    //picUrl
    
    post[@"picUrl"] = m.picUrl;
    //blurPicUrl
    
    post[@"blurPicUrl"] = m.blurPicUrl;
    //id
    
    post[@"mId"] = m.mId;
    
    NSString *mp3name =[NSString stringWithFormat:@"%@.mp3",m.name];
    AVFile *MP3file = [AVFile fileWithName:mp3name data:self.data_mp3];
    
    
    [MP3file save];
    
    [post setObject:MP3file  forKey:@"MP3file"];
    
    
    
    
    
    
    NSString *picname =[NSString stringWithFormat:@"%@.jpg",m.name];
    AVFile *picfile = [AVFile fileWithName:picname data:self.data_pic];
    
    
    [picfile save];
    
    [post setObject:picfile  forKey:@"picfile"];
    
    
    
    
    
    
    NSString *blurpicname =[NSString stringWithFormat:@"blur-%@.jpg",m.name];
    AVFile *blurpicfile = [AVFile fileWithName:blurpicname data:self.data_blurpic];
    
    
    [blurpicfile save];
    
    [post setObject:blurpicfile  forKey:@"blurpicfile"];
    
    
    
    if ([post save]) {
        NSLog(@"%@保存成功",m.name);
        return YES;
    } else
    {
        
        
        NSLog(@"%@保存失败",m.name);
        
        return NO;
    
    }
    
    
}
@end
