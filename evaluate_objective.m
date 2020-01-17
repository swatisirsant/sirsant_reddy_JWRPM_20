function f = evaluate_objective(x, M,V)

%% function f = evaluate_objective(x, M, V)
% Function to evaluate the objective functions for the given input vector
% x. x is an array of decision variables and f(1), f(2), etc are the
% objective functions. The algorithm always minimizes the objective
% function hence if you would like to maximize the function then multiply
% the function by negative one. M is the numebr of objective functions and
% V is the number of decision variables. 
%
% This functions is basically written by the user who defines his/her own
% objective function. Make sure that the M and V matches your initial user
% input. Make sure that the 
%
% An example objective function is given below. It has two six decision
% variables are two objective functions.

% f = [];
% %% Objective function one
% % Decision variables are used to form the objective function.
% f(1) = 1 - exp(-4*x(1))*(sin(6*pi*x(1)))^6;
% sum = 0;
% for i = 2 : 6
%     sum = sum + x(i)/4;
% end
% %% Intermediate function
% g_x = 1 + 9*(sum)^(0.25);
% 
% %% Objective function two
% f(2) = g_x*(1 - ((f(1))/(g_x))^2);

%% Kursawe proposed by Frank Kursawe.
% Take a look at the following reference
% A variant of evolution strategies for vector optimization.
% In H. P. Schwefel and R. Männer, editors, Parallel Problem Solving from
% Nature. 1st Workshop, PPSN I, volume 496 of Lecture Notes in Computer 
% Science, pages 193-197, Berlin, Germany, oct 1991. Springer-Verlag. 
%
% Number of objective is two, while it can have arbirtarly many decision
% variables within the range -5 and 5. Common number of variables is 3.
setdata('EN_DIAMETER',x);
ENsolveH();
head=getdata('EN_PRESSURE');
ele=getdata('EN_ELEVATION');
% tot_h=head+ele;
dem=getdata('EN_BASEDEMAND');
q=getdata('EN_FLOW');
f = [];
% Objective function one
ch = [25.4 50.8 76.2 101.6 152.4 203.2 254 304.8 355.6 406.4 457.2 508 558.8 609.6];    
cost=  [2 5 8 11 16 23 32 50 60 90 130 170 300 550];

cst =[];
for j=1:8
    for k=1:14
       if round(x(j)*1000)==round(ch(k)*1000);
            cst(j,1)=1000.*cost(k);
       end
    end
end
netcost=sum(cst,1);
for j=1:6
    if head(7,j)<27
        DH(j)=27-head(7,j);
    else
        DH(j)=0;
    end
end
DHmax=max(DH);
netcost=DHmax*10^15+netcost;
% Decision variables are used to form the objective function.
f(1) = netcost;

% Objective function two
ND=6;
start_node=[1 2 2 4 4 6 3 7]; %start node id of each pipe
end_node=[2 3 4 5 6 7 5 5]; %end node id of each pipe
tot_dem=sum(dem);

Npipes=8;
for it=1:24
    fact=zeros(1,ND+1);
for i=2:ND+1
    temp1=(start_node==i);
    n_out=sum(temp1); %no of links with start node as i
    temp2=(end_node==i);
    n_in=sum(temp2); %no of links with end node as i
%     n_links=n_in+n_out; %total no of links connected to node i
    outflow=[];
    inflow=[];
    for j=1:Npipes
        if temp1(j)==1
            if q(it,j)>=0
                outflow=[outflow q(it,j)];
            else
                inflow=[inflow -q(it,j)];
            end
        end
        if temp2(j)==1
            if q(it,j)>=0
                inflow=[inflow q(it,j)];
            else
                outflow=[outflow -q(it,j)];
            end
        end
    end
    if isempty(outflow)
%         fact(1,i)=0;
        continue;
    end 
    outflow=[outflow dem(i-1)];  
    tot_sup=sum(inflow);
    n_outflow=length(outflow);
    for j=1:n_outflow
        fact(1,i)=fact(1,i)-(outflow(j)*log(outflow(j)/tot_sup));
    end
    fact(1,i)=fact(1,i)/tot_dem;
end
entp(it)=sum(fact);
end
entropy=mean(entp);

% Decision variables are used to form the objective function.
f(2) = -entropy;

%% Check for error
if length(f) ~= M
    error('The number of decision variables does not match you previous input. Kindly check your objective function');
end