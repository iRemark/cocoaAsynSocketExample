//
//  ViewController.m
//  Client
//
//  Created by lc-macbook pro on 2017/10/23.
//  Copyright © 2017年 http://www.cnblogs.com/saytome/. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *ipField;
@property (weak, nonatomic) IBOutlet UITextField *portField;
@property (weak, nonatomic) IBOutlet UITextField *sendMsgField;
@property (weak, nonatomic) IBOutlet UITextView *reciveMsgTextView;


//客户端socket
@property (nonatomic) GCDAsyncSocket *clientSocket;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //1、初始化
    self.ipField.text = @"172.16.1.6";
    self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)linkButtonAction:(id)sender {
    //连接服务器
    [self.clientSocket connectToHost:self.ipField.text onPort:self.portField.text.integerValue withTimeout:-1 error:nil];
}
- (IBAction)sendMsgButtonAction:(id)sender {
    NSData *data = [self.sendMsgField.text dataUsingEncoding:NSUTF8StringEncoding];
    //withTimeout -1 :无穷大
    //tag： 消息标记
    [self.clientSocket writeData:data withTimeout:-1 tag:0];
}

- (void)showMessageWithText:(NSString *)text {
    self.reciveMsgTextView.text = [self.reciveMsgTextView.text stringByAppendingFormat:@"%@\n", text];
}

#pragma mark - GCDAsynSocket Delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    [self showMessageWithText:@"链接成功"];
    [self showMessageWithText:[NSString stringWithFormat:@"服务器IP ： %@", host]];
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}

//收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self showMessageWithText:text];
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end

