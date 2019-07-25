% ���Թ����ռ�
% plot(x_real.data,y_real.data,'r-',x_predict.data,y_predict.data,'k-')

% input1��MPC���������ǰ��ת�ǣ�2��ʵ���ٶȣ�3�Ƿ�����ת�أ�4�Ƿ����̽��ٶȣ�5������1-ʵ��4�Ĳ�ֵ
% output��0.2s�������delta-ʵ��delta
% save NNdata290.mat
% load NNdata80.mat

% ����zero-orderd��ԭ��delta_real��tʱ�̼�¼��������ʵ��t-1ʱ�̵ģ���¼��λ��0.05s
% ��ʵ���ӳٻ���0.2s��ֻ��input�ļ�¼�ӳ��ˣ�real��t=6��= predict��t=1��



clc; clear;
load double_lane_change_0.2s_0.02_2.mat
% load double_lane_change_0.2s_0.02.mat

% 24s*20=480  ��ʱ0.1s������0.05s ����Ԥ��δ��2����
% �������ԽСԽ��Ԥ�⣬���Կ��Բ���С��ʱ���Ķ���u���������
input1 = delta_predict.data(1:360,1);
%input2 = v_real.data(1:360,1);
input3 = steer_torque.data(1:360,1);
input4 = omega.data(1:360,1); 
% input4 = delta_real.data(1501:5795,1);
% input5 = delta_predict.data(1:360,1) -  delta_real.data(1:360,1);

% input_train = [input1, input2, input3,input4, input5]';
input_train = [input1, input3, input4]';

input_train = con2seq(input_train);

future_err = (delta_predict.data(5:364,1) - delta_real.data(6:365,1))';
output_train = con2seq(future_err);

n=3;        % Ӧ����x����������Ϊ��x(t-0) ����> x(t-3)
m=0;
net1 = timedelaynet(m:n,[3]);         % �����ڹ�ȥx��y������ʱ�䵥λ��ֵ��������10���ڵ�

% narxnet(inputDelays,feedbackDelays,hiddenSizes,trainFcn) takes these arguments,
% inputDelays     Row vector of increasing 0 or positive delays (default = 1:2)
% feedbackDelays  Row vector of increasing 0 or positive delays (default = 1:2)
% hiddenSizes     Row vector of one or more hidden layer sizes (default = 10)
% trainFcn        Training function (default = 'trainlm')

net1.divideFcn = '';
net1.trainParam.min_grad = 1e-15;
net1.trainParam.epochs = 25; 
% net1.trainParam.lr = 0.005;

[Xs,Xi,Ai,Ts] = preparets(net1,input_train,output_train);  % ����׼��
% Prepare input and target time series data for network simulation or training
% [Xs,Xi,Ai,Ts,EWs,shift] = preparets(net,Xnf,Tnf,Tf,EW) takes these arguments,
% p     Xs	Shifted inputs              2x4289 cell  ÿ��cell��3+1
% Pi    Xi	Initial input delay states   2x6   cell ��ʼ������
% Ai    Ai	Initial layer delay states      û����
% t     Ts	Shifted targets         1x4289 Ŀ��ֵ

net1 = train(net1,Xs,Ts,Xi);  % ѵ����û���� Ai
% save ('newdata+buchang80_2_TDnet')      % ֻ���˵ڶ��ε����ܵ�80s������
% view(net1)


% net2 = removedelay(net1,m);       ����removedelay��
% view(net2)
net2 = net1;

% �������Բ�����output_test�ˣ�
% save ('net_narx290_removedelay')
 gensim(net2, 0.05)

% ���������������һ�飬���Լ���
% input_test1 = delta_predict.data(1:1495,1);
% input_test2 = v_real.data(1:1495,1);
% input_test3 = steer_torque.data(1:1495,1);
input_test1 = delta_predict.data(1:475,1);
% input_test2 = v_real.data(1:477,1);
input_test3 = steer_torque.data(1:475,1);
input_test4 = omega.data(1:475,1);


% input_test4 = delta_real.data(1:1495,1);
% input_test5 = delta_predict.data(1:475,1) -  delta_real.data(1:475,1);

% input_test = [input_test1, input_test2, input_test3, input_test4, input_test5]';
% input_test = [input_test1, input_test2, input_test3]';
input_test = [input_test1, input_test3, input_test4]';

input_test = con2seq(input_test);

% future_err_test = (delta_predict.data(5:1499,1) - delta_real.data(6:1500,1))';
future_err_test = (delta_predict.data(5:479,1) - delta_real.data(6:480,1))';

output_test = con2seq(future_err_test);

[Xs1,Xi1,Ai1,Ts1] = preparets(net2,input_test,{});    % ����׼��

predict_err = sim(net2,Xs1,Xi1);          % ����,yp��Ԥ������

[Xs1,Xi1,Ai1,Ts1] = preparets(net2,input_test,output_test);    % ����׼��
e = cell2mat(predict_err)-cell2mat(Ts1);      % ΪʲôҪ��cell2mat������������ƣ���� - ������ʵ�ʣ����
% x = (5+n:1499)/20;
x = (5+n:479)/20;

figure(1)
plot(x,e,'b')
xlabel('t/s')
ylabel('delta error/rad')
legend('err_err')

figure(2)
plot(x,cell2mat(predict_err),'r',x,cell2mat(Ts1),'k')
xlabel('t/s')
ylabel('delta error/rad')
legend('predict_err','real_err')
% x1 = (1:317)/10;
% x2 = (1:801)/10;
%plot(x1,v_predict.data,'r-',x2,v_real.data,'k-');



