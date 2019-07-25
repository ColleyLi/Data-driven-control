% ��ʵ���ܵ����ݣ�ѵ����TDNN���磬��ȥ����ʵ������
%��������1��ţ�2ʱ�䣬3ʵ��ת��4cmdת��5������,6�ٶȣ�7Ť��
clc; clear;
data = xlsread('D:/science/neuralnetwork/sourcecode/predictrealdata/steering_data.xlsx','sheet2');


input1 = [data(11:3000, [4, 6, 7, 3]); data(7001:8211, [4, 6, 7, 3])];
input_train = [input1]';
input_train = con2seq(input_train);

output_train =  [data(15:3004, 4) - data(15:3004, 3); data(7005:8215, 4) - data(7005:8215, 3)]';
output_train = con2seq(output_train);



n=5;
m=0;
net1 = timedelaynet(m:n,[8 6]);         % �����ڹ�ȥx��n��ʱ�䵥λ��ֵ��������10���ڵ�

% net1.divideFcn = '';
net1.divideParam.trainRatio = 70/100;
net1.divideParam.valRatio   = 15/100;
net1.divideParam.testRatio  = 15/100;
net1.trainParam.max_fail = 8;

net1.trainParam.min_grad = 1e-10;
net1.trainParam.epochs = 200;

[Xs,Xi,Ai,Ts] = preparets(net1,input_train,output_train);  % ����׼��
% Prepare input and target time series data for network simulation or training
% [Xs,Xi,Ai,Ts,EWs,shift] = preparets(net,Xnf,Tnf,Tf,EW) takes these arguments,
% p     Xs	Shifted inputs              2x4289 cell  ÿ��cell��3+1
% Pi    Xi	Initial input delay states   2x6   cell ��ʼ������
% Ai    Ai	Initial layer delay states      û����
% t     Ts	Shifted targets         1x4289 Ŀ��ֵ
% tic;
net1 = train(net1,Xs,Ts,Xi);  % ѵ����û���� Ai
% toc;
net2 = net1;


input_test1 = data(7001:7990, [4, 6, 7, 3]);
input_test = [input_test1]';
input_test = con2seq(input_test);

future_err_test = (data(7005:7994, 4) - data(7005:7994, 3))';
output_test = con2seq(future_err_test);

[Xs1,Xi1,Ai1,Ts1] = preparets(net2,input_test,{});    % ����׼��
tic;
predict_errT = sim(net2,Xs1,Xi1);          % ����,yp��Ԥ������
toc;
[Xs1,Xi1,Ai1,Ts1] = preparets(net2,input_test,output_test);    % ����׼��
% e = cell2mat(predict_err)-cell2mat(Ts1);      
xT = data(7005+n:7994,1)/50;
%% ����delta error��ͼ
figure(1)
set(gcf,'color','w');
plot(xT,cell2mat(predict_errT),'LineWidth',1,'color','B')
hold on;
plot(xT,cell2mat(Ts1),'LineWidth',2,'color','k')
hold off;
xlabel('time (s)')
ylabel('steering wheel angle error (rad)')
legend('TDNN predicted','Measured')
% �鿴�������Ա༭���������ֺ�

%% ��error������ȥ��delta��ͼ
% y1 = cell2mat(predict_err) + data(7005+n:7994, 3)';      % ��Ԥ���0.2s��Ĳ�ֵe  ������0.2s�����ʵֵ
% y2 = data(7005+n:7994, 4);         % 0.2s������������cmd
% 
% figure(2)
% plot(x,y1,'LineWidth',2,'color','r')
% plot(x,y2,'LineWidth',2,'color','k')
% xlabel('time /s')
% ylabel('delta /rad')
% legend('TDNN predicted','measured')

e = cell2mat(predict_errT)-cell2mat(Ts1);   
MSE = sum(e.^2)/(990-n)          % 0.0123   0.0125  0.011
RMSE = MSE^0.5                   % 0.111    0.112   0.105
MAE = sum(abs(e))/(990-n)        %          0.0687
min_e = min(e)
max_e = max(e)
cc=corrcoef(cell2mat(predict_errT),cell2mat(Ts1))
