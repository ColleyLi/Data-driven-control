function [sys,x0,str,ts] = MY_MPCController3(t,x,u,flag)
% �Ƚ���������������ĺ��壺t�ǲ���ʱ�䣬x��״̬������u�����루������simulinkģ������룩,
% flag�Ƿ�������е�״̬��־���������жϵ�ǰ�ǳ�ʼ���������еȣ���sys�������flag�Ĳ�ͬ����ͬ
% �����潫���flag����sys�ĺ��壩��x0��״̬�����ĳ�ʼֵ��str�Ǳ���������mathworks��˾��û���
% ����ô������һ���ڳ�ʼ���н����ÿվͿ�����,str=[])��ts��һ��1��2��������ts(1)�ǲ������ڣ�ts(2)��ƫ������
%  http://blog.sina.com.cn/s/blog_628dd2bc0102uy7s.html

%   �ú�����д�ĵ�3��S����������(MATLAB�汾��R2011a)
%   �޶��ڳ����˶�ѧģ�ͣ�������Ϊ�ٶȺ�ǰ��ƫ�ǣ�ʹ�õ�QPΪ�°汾��QP�ⷨ
%   [sys,x0,str,ts] = MY_MPCController3(t,x,u,flag)
% is an S-function implementing the MPC controller intended for use
% with Simulink. The argument md, which is the only user supplied
% argument, contains the data structures needed by the controller. The
% input to the S-function block is a vector signal consisting of the
% measured outputs and the reference values for the controlled
% outputs. The output of the S-function block is a vector signal
% consisting of the control variables and the estimated state vector,
% potentially including estimated disturbance states.

switch flag,
 case 0%��ʼ��
  [sys,x0,str,ts] = mdlInitializeSizes; % Initialization
  
 case 2%������ɢ״̬��
  sys = mdlUpdates(t,x,u); % Update discrete states
  
 case 3%�������
  sys = mdlOutputs(t,x,u); % Calculate outputs
 


 case {1,4,9} % Unused flags
  sys = [];
  
    otherwise%δ֪��flagֵ
  error(['unhandled flag = ',num2str(flag)]); % Error handling
end
% End of dsfunc.

%==============================================================
% Initialization
%==============================================================

function [sys,x0,str,ts] = mdlInitializeSizes

% Call simsizes for a sizes structure, fill it in, and convert it 
% to a sizes array.

sizes = simsizes;
sizes.NumContStates  = 0;%����״̬������       ����ģ���е�case 1�����ù���
sizes.NumDiscStates  = 8;%��ɢ״̬������
sizes.NumOutputs     = 2;%������ĸ���
sizes.NumInputs      = 8;%�������ĸ���
sizes.DirFeedthrough = 1; % Matrix D is non-empty.
sizes.NumSampleTimes = 1;%����ʱ��ĸ���
sys = simsizes(sizes); % �ڳ�ʼ������Ľṹ�Է���s�����Ĺ淶֮��Ӧ���ٴε���simsize�����ṹת��Ϊһ�����Ա�Simulink�����������

x0 =[0;0;0;0;0;0;0;0];        % x0��״̬�����ĳ�ʼֵ,[0;0;0]������״̬������ע���Ƿֺţ�������
global U;
U=[0;0];
% Initialize the discrete states.
str = [];             % Set str to an empty matrix.�������������ù�
ts  = [0.05 0];       % sample time: [period, offset]����ʱ��0.1s����������ɢϵͳ��������Ϊ0��ʾ����ϵͳ��
%End of mdlInitializeSizes
		      
%==============================================================
% Update the discrete states
%==============================================================
function sys = mdlUpdates(t,x,u)
  
sys = x;                % %sys��Ϊx(k+1) 
%End of mdlUpdate.

%==============================================================
% Calculate outputs
%==============================================================
function sys = mdlOutputs(t,x,u)
    global a b u_piao;
    global U;
    global kesi;
   % tic
    Nx = 3;%״̬���ĸ���
    Nu = 2;%�������ĸ���
    Np =60;%Ԥ�ⲽ��                   %�Ĵ󿴿�
    Nc= 30;%���Ʋ���
    Row=10;%�ɳ�����
  %  fprintf('Update start, t=%6.3f\n',t)
    t_d =u(3)*3.1415926/180;%CarSim�����Ϊ�Ƕȣ��Ƕ�ת��Ϊ����  u�����룬u��3����ʾ��������������
    
    % ʵ��ƫ������ u(3) --> t_d

%    %ֱ��·��
  %   r(1)=5*t;
  %   r(2)=5;
  %   r(3)=5*t;
  %  vd1=5;
  %   vd2=0;
  %% =====================================================================
    %�뾶Ϊ25m��Բ�ι켣,�ٶ�Ϊ5m/s
    %r(1)=25*sin(0.2*t);
    %r(2)=25-25*cos(0.2*t);
    
    % ɾ������ƫ���ǿ���
    r(1)=u(4);      % ����ĵ�ͼx����ֵ��15.6
    r(2)=u(5);      % ����ĵ�ͼy
    r(3)=u(6)*3.1415926/180;      % �������������ǣ��Ƕȱ仡��
        
    vd1=u(8);                   % ���ʵ�����ݵ������ٶ�
    % vd1=3;                    % ����������,�𽥼��٣�Ȼ��Ͳ�����
    % vd2=0.104;               % ����ɶ�� delta r
    vd2=0;                 % ���������� ����ʵת��ʱ�ϵģ�������û����
 %% =====================================================================  
%     %�뾶Ϊ25m��Բ�ι켣,�ٶ�Ϊ3m/s
%     r(1)=25*sin(0.12*t);
%     r(2)=25+10-25*cos(0.12*t);
%     r(3)=0.12*t;
%     vd1=3;
%     vd2=0.104;
	%�뾶Ϊ25m��Բ�ι켣,�ٶ�Ϊ10m/s
%      r(1)=25*sin(0.4*t);
%      r(2)=25+10-25*cos(0.4*t);
%      r(3)=0.4*t;
%      vd1=10;
%      vd2=0.104;
    kesi=zeros(5,1);                        % ����ĳ�4��
    kesi(1)=u(1)-r(1);%u(1)(2)������12��������ʵ��λ��
    kesi(2)=u(2)-r(2);%r(1)(2)������45����Ŀ���
    
    kesi(3)=(t_d-r(3)); %u(3)==X(3)   u��123��������״̬����ʵʱλ�ã���r�ǹ켣��
    % t_d��ʵ��ƫ���ǣ����ȣ�r(3)������ƫ���ǣ�����
    
    kesi(4)=U(1);                   % ����ɶ��������59�и���ֵ[0;0]���� �ǿ�����
    kesi(5)=U(2);
    %fprintf('Update start, u(1)=%4.2f\n',U(1))
    %fprintf('Update start, u(2)=%4.2f\n',U(2))      

    T=0.05;
    T_all=40;%��ʱ�趨���ܵķ���ʱ�䣬��Ҫ�����Ƿ�ֹ���������켣Խ��
    % Mobile Robot Parameters
    L = 2.6;        % ���
    % Mobile Robot variable
    
    
%�����ʼ��   
    u_piao=zeros(Nx,Nu);            % 3,2
    Q=eye(Nx*Np,Nx*Np);             % ״̬������3 * Ԥ�ⲽ��60  
    R=8*eye(Nu*Nc);                 % ��λ���󣬿���������2 * ���Ʋ���Nc30
    % ֮ǰ5���ĳ�8
    % ���Ӧ����78ҳ��R���󣬸Ĵ�R��ʹ������u�ĳͷ����󣬼�С������λ��
    
    a=[1    0   -vd1*sin(t_d)*T;    % ��Ӧ��77ҳ
       0    1   vd1*cos(t_d)*T;
       0    0   1;];
    b=[cos(t_d)*T   0;
       sin(t_d)*T   0;
       tan(vd2)*T/L      vd1*T/(cos(vd2)^2);];
   %ʽ��4.6��
   
    A_cell=cell(2,2);
    B_cell=cell(2,1);
    A_cell{1,1}=a;
    A_cell{1,2}=b;
    A_cell{2,1}=zeros(Nu,Nx);
    A_cell{2,2}=eye(Nu);            % ��λ����
    B_cell{1,1}=b;
    B_cell{2,1}=eye(Nu);
    A=cell2mat(A_cell);
    B=cell2mat(B_cell);
    C=[1 0 0 0 0;
       0 1 0 0 0;
       0 0 1 0 0;];
    %ʽ��4.10��
    
    PHI_cell=cell(Np,1);            % Ԥ�ⲽ��NP=60
    THETA_cell=cell(Np,Nc);
    for j=1:1:Np
        PHI_cell{j,1}=C*A^j;
        for k=1:1:Nc                % ���Ʋ���Nc=30
            if k<=j
                THETA_cell{j,k}=C*A^(j-k)*B;
            else 
                THETA_cell{j,k}=zeros(Nx,Nu);
            end
        end
    end
    PHI=cell2mat(PHI_cell);%size(PHI)=[Nx*Np Nx+Nu]
    THETA=cell2mat(THETA_cell);%size(THETA)=[Nx*Np Nu*(Nc+1)]
    %ʽ��4.12��
    
    H_cell=cell(2,2);
    H_cell{1,1}=THETA'*Q*THETA+R;
    H_cell{1,2}=zeros(Nu*Nc,1);
    H_cell{2,1}=zeros(1,Nu*Nc);
    H_cell{2,2}=Row;
    H=cell2mat(H_cell);
    error=PHI*kesi;     % ��Ӧ����80ҳet
                        % [180,1] = [180,5]*[5,1] ���ֵ�ֱ�Ϊ����״̬��123������������45��
                        % kesi��123����״̬������ʱ��t�仯��������û��error������kesi��45��=0
    f_cell=cell(1,2);
    f_cell{1,1}=2*error'*Q*THETA;
    f_cell{1,2}=0;
%     f=(cell2mat(f_cell))';
    f=cell2mat(f_cell);             % ��Ӧ����Gt
    %���϶�Ӧ��4.19��
 %% ����ΪԼ����������
 %����ʽԼ��
    A_t=zeros(Nc,Nc);%��falcone���� P181   % ���Ʋ���Nc=30
    for p=1:1:Nc     % ����ȫ��1��������
        for q=1:1:Nc
            if q<=p 
                A_t(p,q)=1;
            else 
                A_t(p,q)=0;
            end
        end 
    end 
    A_I=kron(A_t,eye(Nu));% ����80ҳ��ʽ��4.17������Ӧ��falcone����Լ������ľ���A,������ڿ˻�kron()
    Ut=kron(ones(Nc,1),U);%�˴��о�������Ŀ����ڿƻ�������,��ʱ����˳��
    
%     umin=[-0.2;-0.54;];%ά������Ʊ����ĸ�����ͬ
%     umax=[0.2;0.332];
if u(7)>20
    umin=[-1;-0.4]; 
    umax=[1;0.4];
    delta_umin=[-0.05;-0.02];
    delta_umax=[0.05;0.02];
elseif u(7)>10
    umin=[-1;-0.55]; % ��Լ���ſ�5m/s���ٶȿ����������ƣ����������Ĳ�ֵ����0.5rad��ǰ��ת������
    umax=[1;0.55];
    delta_umin=[-0.05;-0.008];%%%%%%%%%%����ɶʱ����Ŵ��ˣ���������
    delta_umax=[0.05;0.008];
else
    umin=[-1;-0.55];
    umax=[1;0.55];
    delta_umin=[-0.05;-0.03];
    delta_umax=[0.05;0.03];
end

    Umin=kron(ones(Nc,1),umin);
    Umax=kron(ones(Nc,1),umax);
    A_cons_cell={A_I zeros(Nu*Nc,1);-A_I zeros(Nu*Nc,1)};   % ��϶��ι滮���壬A_I <= Umax-Ut, -A_I <= -Umin+Ut
            %����Ͳ�̫���ˣ�quadprog���ι滮���⣬��80ҳ��׼������ʲô��
    b_cons_cell={Umax-Ut;-Umin+Ut};
    A_cons=cell2mat(A_cons_cell);%����ⷽ�̣�״̬������ʽԼ���������ת��Ϊ����ֵ��ȡֵ��Χ
    b_cons=cell2mat(b_cons_cell);%����ⷽ�̣�״̬������ʽԼ����ȡֵ
   % ״̬��Լ��
    M=10; 
    delta_Umin=kron(ones(Nc,1),delta_umin);
    delta_Umax=kron(ones(Nc,1),delta_umax);
    lb=[delta_Umin;0];%����ⷽ�̣�״̬���½磬��������ʱ���ڿ����������ɳ�����
    ub=[delta_Umax;M];%����ⷽ�̣�״̬���Ͻ磬��������ʱ���ڿ����������ɳ�����
    
    %% ��ʼ������
    % options = optimset('Algorithm','active-set');
    options = optimset('Algorithm','interior-point-convex'); 
    [X,fval,exitflag]=quadprog(H,f,A_cons,b_cons,[],[],lb,ub,[],options);
    %% �������
    u_piao(1)=X(1);         % X���������Ŀ�������Ut��u_piao=zeros(Nx,Nu);�Ǹ�[3,2]���󣿣�ά�����ԣ���
    u_piao(2)=X(2);
    U(1)=kesi(4)+u_piao(1);%kesi���ڴ洢��һ��ʱ�̵Ŀ�������u_piao����������Ŀ�����
    U(2)=kesi(5)+u_piao(2);
    u_real(1)=U(1)+vd1;     % ������U v + �����ٶ�
    u_real(2)=U(2)+vd2;     % ������U delta + ǰ��ת��0
    sys= u_real;        %sys��ʱΪ���y
    % toc
% End of mdlOutputs.