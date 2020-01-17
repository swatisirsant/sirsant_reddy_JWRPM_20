%This is the main function for performing multi-objective design of Two loop WDN using NSGA-II for cost minimization and RSM maximization
%Note that the epanet file and functions are required to tun this code
%The RSM may change as per the requirement and individual codes for each RSM is available separately

clear all;
clc;
wdsfile='TL1.inp';
addpath('G:\matlab_codes\Epanet files');
epanetloadfile(wdsfile);
Demand=getdata('EN_BASEDEMAND');
Length=getdata('EN_LENGTH');
Nnodes=6;
Npipes=8;
ele=getdata('EN_ELEVATION');
NP = input('Enter the population size \n');
Imax = input('Enter the maximum number of iterations \n');
M=2; V=Npipes;
suc=1;
Nobj=2;
n_sim=1000;
dia=[25.4 50.8 76.2 101.6 152.4 203.2 254 304.8 355.6 406.4 457.2 508 558.8 609.6];
l_lim=ones(1,8)*25.4;
u_lim=ones(1,8)*609.6;
% Hmin = ones(1,Nnodes)*30;
diaa = randsample(dia,NP*Npipes,true);
chromosome=reshape(diaa,NP,Npipes); %initial population
chromosome(1,:)=[457.2 254 406.4 101.6 406.4 254 254 25.4];
% chromosome=diab;
for i=1:NP
    diac=chromosome(i,1:Npipes);
%     chromosome(i,:)=diac;
    netcost=TL_netcost(diac);
    setdata('EN_DIAMETER',diac);
    ENsolveH();
    head=getdata('EN_PRESSURE');
    for j=1:25
        tot_h(j,:)=head(j,:)+ele(1,:);
    end
    Flow=getdata('EN_FLOW');
%     pause
    for j=1:6
        if head(7,j)<27
            DH(j)=27-head(7,j);
        else
            DH(j)=0;
        end
    end
    DHmax=max(DH);
    penalty=DHmax*(10^15);
    netcost=netcost+penalty;
    chromosome(i,Npipes+1)=netcost;
%     pause
    chromosome(i,Npipes+2)=(-1)*CERI_TL_ext(tot_h,Demand,Flow);
end
fileID=fopen('TL_NSGA_II_CERI_1.txt','w');
fprintf(fileID,'Population size is %d',NP);
%% Sort the initialized population
chromosome = non_domination_sort_mod(chromosome, 2, 8);

tic
for i=1:Imax
    offspring =GA_new_gen_CERI(chromosome,Npipes,NP,l_lim,u_lim);
    % Intermediate population
    % Intermediate population is the combined population of parents and
    % offsprings of the current generation. The population size is two
    % times the initial population.
    
    [main_pop,temp] = size(chromosome);
    [offspring_pop,temp] = size(offspring);
    % temp is a dummy variable.
    clear temp
    % intermediate_chromosome is a concatenation of current population and
    % the offspring population.
    intermediate_chromosome(1:main_pop,:) = chromosome;
    intermediate_chromosome(main_pop + 1 : main_pop + offspring_pop,1 : M+V) = ...
        offspring;

    % Non-domination-sort of intermediate population
    % The intermediate population is sorted again based on non-domination sort
    % before the replacement operator is performed on the intermediate
    % population.
    intermediate_chromosome = ...
        non_domination_sort_mod(intermediate_chromosome, M, V);
    % Perform Selection
    % Once the intermediate population is sorted only the best solution is
    % selected based on it rank and crowding distance. Each front is filled in
    % ascending order until the addition of population size is reached. The
    % last front is included in the population based on the individuals with
    % least crowding distance
    chromosome = replace_chromosome(intermediate_chromosome, M, V, NP);
    if ~mod(i,100)
        clc
        fprintf('%d generations completed\n',i);
    end
    fprintf(fileID,'Sorted population after iteration %d is: \r\n',i);
    for j=1:NP
        fprintf(fileID,'%.3f ',chromosome(j,:));
        fprintf(fileID,'\r\n');
    end
    clear intermediate_pop;
    clear offspring;
end
d=0;
for i=1:NP
    if chromosome(i,Npipes+3)==1
        d=d+1;
    else
        break;
    end
end
for i=1:d
    Fr1(i)=chromosome(i,Npipes+1);
    Fr2(i)=chromosome(i,Npipes+2);
end
[F2_s,ind]=sort(Fr2);
for i=1:d
    ch_temp(i,1:Npipes)=chromosome(ind(i),1:Npipes);
    F1_s(i)=Fr1(ind(i));
end
c=1;
i=1;
f_c=1;
t=1;
while i<d
    for j=c:d-1
        if (round(F2_s(j+1)*10^3)==round(F2_s(j)*10^3))
            c=c+1;
        else
            c=c+1;
            break;
        end
    end
    [temp,in]=min(F1_s(t:c-1));
    X(f_c)=temp;
    Y(f_c)=F2_s(c-1);
    final_ch(f_c,:)=ch_temp(t+in-1,:);
    f_c=f_c+1;
    t=c;
    i=c;
end
if F1_s(c)~=F1_s(c-1)
    final_ch(f_c,1:Npipes)=ch_temp(c,:);
    X(f_c)=F1_s(c);
    Y(f_c)=F2_s(c);
else
    f_c=f_c-1;
end
for i=1:f_c
    final_ch(i,Npipes+1)=X(i);
    final_ch(i,Npipes+2)=Y(i);
end

% Rel_h=zeros(1,f_c);
% Rel_m=zeros(1,f_c);
% % epanetloadfile(wdsfile);
% for i=1:f_c
%     diac=final_ch(i,1:Npipes);
%     Rel_h(i)=rel_TL_mcs(diac,Demand,1000);
%     final_ch(i,Npipes+3)=Rel_h(i);
%     Rel_m(i)=rel_TL_mech(diac,Demand,Length);
%     final_ch(i,Npipes+4)=Rel_m(i);
% end
% final_ch(i,Npipes+1)=TL_netcost(diac);
% final_ch(i,Npipes+2)=-Entp_TL(diac,Demand);
fprintf(fileID,'\r\n Final pareoto optimal solutions are \r\n');
for i=1:f_c-1
    fprintf(fileID,'%.3f',final_ch(i,:));
    fprintf(fileID,'\r\n');
end
toc
plot(X,Y);
epanetclose();
fclose(fileID);  