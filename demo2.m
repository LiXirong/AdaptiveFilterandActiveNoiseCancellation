% ------------------------------------------------------------------------ 
%  Copyright (C)
%  LiXirong - Wuhan University, China
% 
%  LiXirong <634602068@qq.com> or <lixirong@whu.edu.cn>
%  2018.10.15
% ------------------------------------------------------------------------
%
% demo2.m - ANC demo（使用自适应滤波算法的ANCdemo）
% Including LMS、NLMS、RLS algorithm
% Including：
%     1、audio + white noise 音频白噪声消除
%     2、single frequency signal + white noise 单频白噪声消除
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

%% 1、audio + white noise（音频+白噪声）
[d,fs] = audioread('handel.wav');
d = d';
n = length(d);
noise = wgn(n, 1, -20)';
x = d + noise;
d = noise;

%% 2、single frequency signal + white noise（单频+白噪声）
% fs = 16000;
% t = 0:1/fs:3;
% noise = wgn(length(t),1,-10)';
% x = noise + cos(2*pi*t*200);
% d = noise;

%% LMS\NLMS\RLS performance（LMS\NLMS\RLS性能比较）

% set parameters (设置参数)
mu =  0.01;
mu2 = 0.01;
a = 0.01;
lamda = 0.1;
M = 80;

% run algorithm (运行算法)
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

% 画出参考信号与滤波输出的差值(ANC输出信号)
figure()
subplot(3,1,1)
plot(x-y1)
title('LMS ANC输出')
subplot(3,1,2)
plot(x-y2)
title('NLMS ANC输出')
subplot(3,1,3)
plot(x-y3)
title('RLS ANC输出')

% 比较稳定后的信噪比
% xx1 = clearspeech(length(x)-3000:length(x));
% ee1 = e1(length(x)-3000:length(x));
% ee2 = e2(length(x)-3000:length(x));
% ee3 = e3(length(x)-3000:length(x));
% yy1 = y1(length(x)-3000:length(x));
% yy2 = y2(length(x)-3000:length(x));
% yy3 = y3(length(x)-3000:length(x));
% SNR1 = snr(xx1,ee1)
% SNR2 = snr(xx1,ee2)
% SNR3 = snr(xx1,ee3)

%% 试听RLS ANC的输出结果（RLS效果最好）
% sound(x-y3,fs);
