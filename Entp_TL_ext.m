function entropy = Entp_TL_ext(q,dem)
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