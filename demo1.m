% ------------------------------------------------------------------------ 
%  Copyright (C)
%  LiXirong - Wuhan University, China
% 
%  LiXirong <634602068@qq.com> or <lixirong@whu.edu.cn>
%  2018.10.15
% ------------------------------------------------------------------------
%
% demo1.m - adaptive filter demo（自适应滤波算法应用demo）
% Including LMS、NLMS、RLS algorithm
% Including：
%     1、echo cancellation 音频回声消除
%     2、audio + white noise 音频白噪声消除
%     3、audio + single frequency noise 音频+单频噪声消除
%     4、single frequency signal + white noise 单频信号+白噪声消除
%     5、multi-frequency signal + single frequency signal noise 多频信号+单频声消除
% Parameters：
%     x     ： input signal      输入信号
%     d     ： reference signal  参考信号
%     y     ： output signal     输出信号
%     e     ： error signal      误差信号
%     mu    ： LMS stepsize      LMS算法步长
%     mu2   ： NLMS stepsize     NLMS算法步长
%     a     ： NLMS bias         NLMS算法偏置参数
%     lamda ： RLS weight        RLS算法权重
%
% ------------------------------------------------------------------------

close all;clear;clc;

%% 1、echo cancellation (音频回声)
% [d, fs] = audioread('handel.wav');
% x = audioread('handel_echo.wav');
% d = d';
% x = x';

%% 2、audio + white noise (音频+白噪声)
% [d,fs] = audioread('handel.wav');
% d = d';
% n = length(d);
% noise = 5 * wgn(n, 1, -20)';
% x = d + noise;

%% 3、audio + single frequency noise (音频+单频噪声)
% [d,fs] = audioread('handel.wav');
% d = d';
% n = length(d);
% 
% noise = cos(2*pi*t*700);
% x = d + noise;
% T = n/fs;
% t = 0:1/fs:T-1/fs;

%% 4、single frequency signal + white noise (单频+白噪声)
fs = 16000;
t = 0:1/fs:2;
noise = wgn(length(t),1,-20)';
d = 0.5*cos(2*pi*t*200);
x = noise + cos(2*pi*t*200);  

%% 5、multi-frequency signal + single frequency signal noise (多频+单频噪声)
% fs = 16000;
% t = 0:1/fs:1;
% d = cos(2*pi*t*200);
% x = cos(2*pi*t*100) + d;

%% LMS\NLMS\RLS performance (LMS\NLMS\RLS性能比较)

% set parameters (设置参数)
mu =  0.001;
mu2 = 0.001;
a = 0.01;
lamda = 0.01;
M = 80;

% run algorithm (运行算法并计算时间)
tic
[e1, y1, w1] = myLMS(d, x, mu, M);
toc
tic
[e2, y2, w2] = myNLMS(d, x,mu2, M, a);
toc
tic
[e3, y3, w3] = myRLS(d, x,lamda,M);
toc

% 画出输入信号、参考信号、滤波输出、误差
figure()
subplot(4,2,1)
plot(x);
title('x');
subplot(4,2,2)
plot(d);
title('d');
subplot(4,2,3)
plot(y1);
title('LMS');
subplot(4,2,5)
plot(y2);
title('NLMS');
subplot(4,2,7)
plot(y3);
title('RLS');
subplot(4,2,4)
plot(e1);
title('LMS error');
subplot(4,2,6)
plot(e2);
title('NLMS error');
subplot(4,2,8)
plot(e3);
title('RLS error');
