% ------------------------------------------------------------------------ 
%  Copyright (C)
%  LiXirong - Wuhan University, China
% 
%  LiXirong <634602068@qq.com> or <lixirong@whu.edu.cn>
%  2018.12.21
% ------------------------------------------------------------------------
% demo3.m - 自适应滤波算法性能比较
% Including LMS、NLMS、RLS algorithm
% Including：
%     1、不同步长的滤波器参数更新曲线对比
%     2、相同步长的LMS算法和NLMS算法滤波器权重更新曲线对比
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

%% audio + single frequency noise （音频+单频噪声）
% [d,fs] = audioread('handel.wav');
% n = length(d);
% T = n/fs;
% t = 0:1/fs:T-1/fs;
% noise = cos(2*pi*t*700)';
% x = d + noise;

%% single frequency signal + white noise （单频+白噪声）
fs = 8000;
t = 0:1/fs:2;
noise = wgn(length(t),1,-20);
d = cos(2*pi*t*723)' + sin(2*pi*t*456)';
x = noise + d;

%% LMS\NLMS\RLS性能比较

% set parameters (设置参数)
mu =  [0.0005 0.001 0.005 0.01];
mu2 = [0.005 0.01 0.05 0.1];
a = 0.01;
lamda = [1 0.9999 0.999 0.99];
M = 20;

% 画出滤波器最后一个参数的变化曲线
figure(1);
for i = 1:length(mu)
    [e1, ~, w1] = myLMS(d, x, mu(i), M);
    c1(i) = {['\mu = ',num2str(mu(i))]};
    subplot(2,1,1)
    plot(w1(M,:)','LineWidth', 1)
    hold on
    subplot(2,1,2)
    plot(e1)
    hold on
end
subplot(2,1,1)
legend(c1)
title('不同步长的LMS算法滤波器参数收敛情况,M=20')
subplot(2,1,2)
legend(c1)
title('不同步长的LMS算法误差收敛情况,M=20')

figure(2) 
for i = 1:length(mu2)
    [e2, ~, w2] = myNLMS(d, x,mu2(i), M, a);
    c2(i) = {['\mu = ',num2str(mu2(i))]};
    subplot(2,1,1)
    plot(w2(M,:)','LineWidth', 1)
    hold on
    subplot(2,1,2)
    plot(e2)
    hold on
end
subplot(2,1,1)
legend(c2)
title('不同步长的NLMS算法滤波器参数收敛情况,M=20')
subplot(2,1,2)
legend(c2)
title('不同步长的NLMS算法误差收敛情况,M=20')

figure(3)
for i = 1:length(lamda)
    [e3, ~, w3] = myRLS(d, x,lamda(i),M);
    c3(i) = {['\lambda = ',num2str(lamda(i))]};
    subplot(2,1,1)
    plot(w3(M,:)','LineWidth', 1)
    hold on
    subplot(2,1,2)
    plot(e3)
    hold on
end
subplot(2,1,1)
legend(c3)
title('不同权重的RLS算法滤波器参数收敛情况,M=20')
subplot(2,1,2)
legend(c3)
title('不同权重的RLS算法误差收敛情况,M=20')

figure(4)
[e1, ~, w1] = myLMS(d, x, 0.001, M);
[e2, ~, w2] = myNLMS(d, x, 0.01, M, a);
[e3, ~, w3] = myRLS(d, x, 0.9999,M);
subplot(2,1,1)
plot(w2(M,:)','LineWidth', 1);
hold on
plot(w1(M,:)','LineWidth', 1);
plot(w3(M,:)','LineWidth', 1);
legend({'NLMS','LMS','RLS'})
title('滤波器参数收敛情况对比：\mu1 = 0.001, \mu2 = 0.01, \lambda = 0.9999,M=20')
subplot(2,1,2)
plot(e2);
hold on
plot(e1);
plot(e3);
legend({'NLMS','LMS','RLS'})
title('误差收敛情况对比：\mu1 = 0.001, \mu2 = 0.01,\lambda = 0.9999,M=20')
