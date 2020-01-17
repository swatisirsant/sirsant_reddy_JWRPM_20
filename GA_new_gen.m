function offspring = GA_new_gen(chromosome,Npipes,NP, min_range, max_range)
% wdsfile='TL.inp';
% addpath('G:\matlab_codes\Epanet files');
% epanetloadfile(wdsfile);
% Cr=0.75;
c=1;
u=zeros(NP,Npipes);
ud=zeros(NP,Npipes);
pool=round(NP/2);
tour=2;
parent=tournament_selection(chromosome, pool, tour);
mu = 20;
mum = 20;
M=2;
V=8;
offspring = genetic_operator(parent,M, V, mu, mum, min_range, max_range);
% for i=1:(NP/2)
%     I=randi(NP/2,1,2);
%     for j=1:Npipes
%         u(c,:)=parent(I(1),1:Npipes)*CR+parent(I(2),1:Npipes)*(1-CR);
%         u(c+1,:)=parent(I(2),1:Npipes)*CR+parent(I(1),1:Npipes)*(1-CR);
%     end
%     sig1=max(u(c,:))*F;
%     sig2=max(u(c+1,:))*F;
%     r=randi(Npipes,1,2);
%     u(c,r(1))=u(c,r(1))+randn*sig1;
%     u(c+1,r(2))=u(c+1,r(2))+randn*sig2;
%     ud(c,:)=Discrete_TL(u(c,:));
%     ud(c+1,:)=Discrete_TL(u(c+1,:));
%     c=c+2;
% end
% for i=1:NP
%         cost=TL_netcost(ud(i,1:Npipes));
%         Entpy=Entp_TL(ud(i,1:Npipes),demand);
%         ud(i,Npipes+1)=cost;
%         ud(i,Npipes+2)=-Entpy;
% end
% offspring=ud;
% epanetclose();

        