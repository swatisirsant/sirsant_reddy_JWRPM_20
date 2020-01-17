function resiliency = Res_TL_ext(head,dem,flow)
Hmin=[180 190 185 180 195 190];
ND=6; 
for it=1:24
    t1=0;
    t2=0;
    for i=1:ND
        t1=t1+(dem(i)*(head(it,i)));
        t2=t2+(dem(i)*Hmin(i));
    end
    t3=1120*210;
    res(it)=(t1-t2)/(t3-t2);
end
resiliency=mean(res);
