function net_res = Net_Res_TL_ext(dia,head,dem)
ND=6;
start_node=[1 2 2 4 4 6 3 7]; %start node id of each pipe
end_node=[2 3 4 5 6 7 5 5]; %end node id of each pipe
% tot_dem=sum(dem);
% fact=zeros(1,ND+1);=
Npipes=8;
U=ones(1,ND);
for i=2:ND+1
    temp1=(start_node==i);
    n_out=sum(temp1); %no of links with start node as i
    temp2=(end_node==i);
    n_in=sum(temp2); %no of links with end node as i
    n_links=n_in+n_out; %total no of links connected to node i
    D=[];
    for j=1:Npipes
        if temp1(j)==1
            D=[D dia(j)];
        end
        if temp2(j)==1
            D=[D dia(j)];
        end
    end
    Dmax=max(D);
    Dtot=sum(D);
    U(i-1)=Dtot/(n_links*Dmax);
end
Hmin=[180 190 185 180 195 190];
for it=1:24
t1=0;
t2=0;
for i=1:ND
    t1=t1+(U(i)*dem(i)*head(it,i));
    t2=t2+(U(i)*dem(i)*Hmin(i));
end
t3=1120*210;
n_res(it)=(t1-t2)/(t3-t2);
end
net_res=mean(n_res);