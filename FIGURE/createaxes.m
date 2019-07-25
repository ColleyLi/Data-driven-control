function createaxes(X1, YMatrix1, X2, Y1, X3, Y2)
%CREATEAXES(X1, YMatrix1, X2, Y1, X3, Y2)
%  X1:  x ���ݵ�����
%  YMATRIX1:  y ���ݵľ���
%  X2:  x ���ݵ�����
%  Y1:  y ���ݵ�����
%  X3:  x ���ݵ�����
%  Y2:  y ���ݵ�����

%  �� MATLAB �� 12-Jan-2019 19:29:51 �Զ�����

% ���� axes
axes1 = axes;
hold(axes1,'on');

% ʹ�� plot �ľ������봴������
plot1 = plot(X1,YMatrix1,'LineWidth',1);
set(plot1(2),'DisplayName','Measured','LineWidth',2,'Color',[0 0 0]);
set(plot1(1),'DisplayName','LSTM','Color',[0 1 0]);
set(plot1(3),'DisplayName','TDNN','Color',[1 0 0]);

% ���� plot
plot(X2,Y1,'DisplayName','BP','LineWidth',1,'Color',[1 1 0]);

% ���� plot
plot(X3,Y2,'DisplayName','NARX','LineWidth',1,'Color',[0 0 1]);

% ���� ylabel
ylabel({'steering wheel angle error/(rad)'},'FontSize',12);

% ���� xlabel
xlabel({'t/(s)'},'FontSize',12);

box(axes1,'on');
