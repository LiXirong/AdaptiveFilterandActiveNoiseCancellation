% ------------------------------------------------------------------------ 
%  Copyright (C)
%  LiXirong - Wuhan University, China
% 
%  LiXirong <634602068@qq.com> or <lixirong@whu.edu.cn>
%  2018.12.21
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
% mu =  0.05;
% mu2 = 0.05;
% a = 0.1;
% lamda = 0.99;
% M = 40;

%% 2、audio + white noise (音频+白噪声)
% [d,fs] = audioread('handel.wav');
% n = length(d);
% noise =  wgn(1, n, -20)';
% x = d + noise;
% mu =  0.001;
% mu2 = 0.1;
% a = 0.01;
% lamda = 0.99;
% M = 80;

%% 3、audio + single frequency noise (音频+单频噪声)
% [d, fs] = audioread('handel.wav');
% n = length(d);
% T = n/fs;
% t = 0:1/fs:T-1/fs;
% noise = cos(2*pi*t*370)';
% x = d + noise;
% 
% mu =  0.005;
% mu2 = 0.05;
% a = 0.1;
% lamda = 0.9999;
% M = 40;

%% 4、single frequency signal + white noise (单频+白噪声)
fs = 8000;
t = 0:1/fs:5;
noise = wgn(1, length(t),-20)';
d = cos(2*pi*t*261.625)';
x = noise + cos(2*pi*t*261.625)';  

mu =  0.0001;
mu2 = 0.001;
a = 0.1;
lamda = 0.999;
M = 40;

%% 5、multi-frequency signal + single frequency signal noise (多频+单频噪声)
% fs = 16000;
% t = 0:1/fs:4;
% d = cos(2*pi*t*200)';
% x = cos(2*pi*t*100)' + d;
% mu =  0.01;
% mu2 = 0.1;
% a = 0.1;
% lamda = 0.9999;
% M = 50;

%% LMS\NLMS\RLS performance (LMS\NLMS\RLS性能比较)

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
plot([1:length(x)]/fs,x);
xlabel('time');
title('x(n)');
subplot(4,2,2)
plot([1:length(d)]/fs,d);
xlabel('time');
title('d(n)');
subplot(4,2,3)
plot([1:length(y1)]/fs,y1);
xlabel('time');
title('LMS y(n)');
subplot(4,2,5)
plot([1:length(y2)]/fs,y2);
xlabel('time');
title('NLMS y(n)');
subplot(4,2,7)
plot([1:length(y3)]/fs,y3);
xlabel('time');
title('RLS y(n)');
subplot(4,2,4)
plot([1:length(e1)]/fs,e1);
xlabel('time');
title('LMS e(n)');
subplot(4,2,6)
plot([1:length(e2)]/fs,e2);
xlabel('time');
title('NLMS e(n)');
subplot(4,2,8)
plot([1:length(e3)]/fs,e3);
xlabel('time');
title('RLS e(n)');
