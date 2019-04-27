//
//  ViewController.m
//  ServerExample
//
//  Created by lc-macbook pro on 2017/10/23.
//  Copyright © 2017年 http://www.cnblogs.com/saytome/. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"

@interface ViewController ()<GCDAsyncSocketDelegate>

/** 端口号 **/
@property (weak, nonatomic) IBOutlet UITextField *portField;

/** 发送消息 **/
@property (weak, nonatomic) IBOutlet UITextField *sendMsgField;

/** 连接端口号按钮 **/
@property (weak, nonatomic) IBOutlet UIButton *linkPortButton;

/** 发送消息按钮 **/
@property (weak, nonatomic) IBOutlet UIButton *sendMsgButton;

/** 接受消息 **/
@property (weak, nonatomic) IBOutlet UITextView *reciveMsgTextView;



//服务器socket（开放端口，监听客户端socket的链接）
@property (nonatomic) GCDAsyncSocket *serverSocket;

//保护客户端socket
@property (nonatomic) GCDAsyncSocket *clientSocket;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //初始化服务器socket
    self.serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    

}

/** 连接端口 **/
- (IBAction)linkPortButtonAction:(id)sender {
    NSError *error = nil;
    BOOL result = [self.serverSocket acceptOnPort:self.portField.text.integerValue error:&error];
    if (result && error == nil) {
        //开放成功
        [self showMessageWithText:@"连接成功"];
    }
}


/** 发消息 **/
- (IBAction)sendMsgButtonAction:(id)sender {
    NSData *data = [self.sendMsgField.text dataUsingEncoding:NSUTF8StringEncoding];
    //withTimeout -1:  一直等
    //tag:消息标记
    [self.clientSocket writeData:data withTimeout:-1 tag:0];
}

- (void)showMessageWithText:(NSString *)text {
    self.reciveMsgTextView.text = [self.reciveMsgTextView.text stringByAppendingFormat:@"%@\n",text];
}

#pragma mark - 服务器socket Delegate
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    //保存客户端的socket
    self.clientSocket = newSocket;
    [self showMessageWithText:@"链接成功"];
    
    [self showMessageWithText:[NSString stringWithFormat:@"服务器地址：%@ -端口： %d", newSocket.connectedHost, newSocket.connectedPort]];
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}

//收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self showMessageWithText:text];
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}


@end
