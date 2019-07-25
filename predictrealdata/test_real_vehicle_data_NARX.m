% ��ʵ���ܵ����ݣ�ѵ����NARX���磬��ȥ����ʵ������


data = xlsread('D:/science/neuralnetwork/sourcecode/predictrealdata/steering_data.xlsx','sheet2');
input1 = [data(11:6000, [4, 6, 7, 3]); data(7001:11211, [4, 6, 7, 3])];
input_train = [input1]';
input_train = con2seq(input_train);

output_train =  [data(11:6000, 4) - data(11:6000, 3); data(7001:11211, 4) - data(7001:11211, 3)]';
output_train = con2seq(output_train);


m1=4;n1=6;        
m2=1;n2=2;
max1 = max(n1-m1,n2-m2);
net_narx = narxnet(m1:n1,m2:n2,[8 6]);  % ������

% net_narx.divideFcn = '';
net_narx.divideParam.trainRatio = 70/100;
net_narx.divideParam.valRatio   = 15/100;
net_narx.divideParam.testRatio  = 15/100;
net_narx.trainParam.max_fail = 8;
net_narx.trainParam.lr = 0.001 ;   

net_narx.trainParam.min_grad = 1e-10;
net_narx.trainParam.epochs = 100;

[Xs,Xi,Ai,Ts] = preparets(net_narx,input_train,{},output_train);  % ����׼��
% Prepare input and target time series data for network simulation or training
% [Xs,Xi,Ai,Ts,EWs,shift] = preparets(net,Xnf,Tnf,Tf,EW) takes these arguments,
% p     Xs	Shifted inputs              2x4289 cell  ÿ��cell��3+1
% Pi    Xi	Initial input delay states   2x6   cell ��ʼ������
% Ai    Ai	Initial layer delay states      û����
% t     Ts	Shifted targets         1x4289 Ŀ��ֵ

% tic;
net_narx = train(net_narx,Xs,Ts,Xi);  % ѵ����û���� Ai
% toc;
%save ('net_narx290')
view(net_narx)



% [Y,Xf,Af] = net_narx(Xs,Xi,Ai);   % Ai��Af���ǿյģ�Xf��ɶ��
% perf = perform(net_narx,Ts,Y)     % Ŀ��ֵTs�����ֵY�Ƚ�   

net_narx2 = closeloop(net_narx);      % open�ǵ���ѵ����close�Ƕಽѵ����Ҫ��Ԥ�����removedelay
% view(net_narx_closed)
net_narx3 = removedelay(net_narx2,4); 
view(net_narx3)
tic;
input_test1 = data(7001:7990, [4, 6, 7, 3]);
input_test = [input_test1]';
input_test = con2seq(input_test);

future_err_test = (data(7001:7990, 4) - data(7001:7990, 3))';
output_test = con2seq(future_err_test);
toc;
% T4 = output_test;
% T = tonndata(T4,false,false);
% [xc,xic,aic,tc] = preparets(net_narx2,input_test,{},T);
% output_test0 = zeros(1,990);
% output_test0 = con2seq(output_test0);

[Xs1,Xi1,Ai1,Ts1] = preparets(net_narx3,input_test,{},{});    % ����׼��
predict_errN = sim(net_narx3,Xs1,Xi1);          % ����,yp��Ԥ������
% predict_err = net_narx2(xc,xic,aic);


[Xs1,Xi1,Ai1,Ts1] = preparets(net_narx3,input_test,{},output_test);    % ����׼��
% e = cell2mat(predict_err)-cell2mat(Ts1);      
xN = (7005+max1:7994)/50;

%% ����delta error��ͼ
set(0,'showhiddenhandles','on');
set(gcf,'menubar','figure');
figure(1)
plot(xN,cell2mat(predict_errN),'LineWidth',1,'color','y')
hold on;
plot(xN,-data(7005+max1:7994, 5),'LineWidth',2,'color','k')
hold off;
xlabel('time (s)')
ylabel('steering wheel angle error (rad)')
legend('NARX predicted','Measured')
% �鿴�������Ա༭���������ֺ�

%% ��error������ȥ��delta��ͼ
% y1 = cell2mat(predict_err) + data(7005+max1:7994, 3)';      % ��Ԥ���0.2s��Ĳ�ֵe  ������0.2s�����ʵֵ
% y2 = data(7005+max1:7994, 4);         % 0.2s������������cmd
% 
% figure(2)
% plot(x,y1,'r',x,y2,'k')
% xlabel('t/s')
% ylabel('delta /rad')
% legend('NARX predicted(shifted)','measured')

e = cell2mat(predict_errN) - (data(7005+max1:7994, 4) - data(7005+max1:7994, 3))'; %%%%%�д�
average=data(7005+max1:7994, 4) - data(7005+max1:7994, 3)/(7994-7005+max1)
MSE = sum(e.^2)/(990-max1)     %  0.0407  0.0268   0.0228   0.0280
RMSE = MSE^0.5                 %  0.202   0.164    0.151    0.167
MAE = sum(abs(e))/(990-max1)   %  0.1164
cc=corrcoef(cell2mat(predict_errN),(data(7005+max1:7994, 4) - data(7005+max1:7994, 3))')
ce= 1- sum(e)*sum(e)/(sum((data(7005+max1:7994, 4) - data(7005+max1:7994, 3)-average)^2))
