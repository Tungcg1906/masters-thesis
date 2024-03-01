function C=cross_corr(ts,delay)

n=size(ts,1);

C=zeros(n)

for i=1:n
for j=1:n

    C(i,j)=corr(ts(i,1:end-delta),ts(j,delta+1:end));

end
end

end


function C=cross_cov(ts,delay)

n=size(ts,1);

C=zeros(n)

for i=1:n
for j=1:n

    size(ts(i,1:end-delta))
    D=corr(ts(i,1:end-delta),ts(j,delta+1:end));
    C(i,j)=D(1,2);

end
end


end

function Ad=dediag(A)
  
 Ad = A - diag(diag(A));
end