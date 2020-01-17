function res_entp = CERI_TL_ext(head,dem,q)
ND=6;
start_node=[1 2 2 4 4 6 3 7]; %start node id of each pipe
end_node=[2 3 4 5 6 7 5 5]; %end node id of each pipe
Hmin=[180 190 185 180 195 190];
tot_dem=sum(dem);
entp_max=2.259816597;
% res_max=0.857110714;
res_max=1;
Npipes=8;
for it=1:24
    fact=zeros(1,ND+1);
    t1=0;
    t2=0;
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
        if outflow(j)>0
        fact(1,i)=fact(1,i)-(outflow(j)*log(outflow(j)/tot_sup));
        end
    end
    fact(1,i)=fact(1,i)/tot_dem;
    t1=t1+(dem(i-1)*head(it,i-1));
    t2=t2+(dem(i-1)*Hmin(i-1));
end
t3=1120*210;
res(it)=(t1-t2)/(t3-t2);
entp(it)=sum(fact);
end
entropy=mean(entp);
resiliency=mean(res);
res_entp=(0.6*resiliency/res_max)+(0.4*entropy/entp_max);