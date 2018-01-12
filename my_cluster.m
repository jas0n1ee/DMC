function [ NC,centers,Y,Y0] = my_cluster( d )
percent = 2;
[N,~] = size(d); %N: sample number
%d = zeros(N,N);
d_l = [];
delta = zeros(N,1);

for i = 1:N
    for j = i+1:N
        %d(i,j) = norm(X(i,:)-X(j,:));
        d_l = [d_l;d(i,j)];
    end
end

d_l = sort(d_l);
dc = d_l(round(percent/100*length(d_l)));


rho = sum(exp(-(d/dc).^2),2) - 1;
rho_max = max(rho);
for i = 1:N
    if(rho(i) == rho_max)
        delta(i) = max(d(:,i));
    else
        delta(i) = min(d(rho>rho(i),i));
    end
end
figure(1);hold on;
plot(rho,delta,'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');

title('decision graph');
xlabel('\rho');
ylabel('\delta');
%disp('画一个包含聚类中心的矩形框');

rect = getrect(1);
rhomin=rect(1);
deltamin=rect(2);

NC = 0;
Y0 = zeros(N,1);

centers = [];
for i = 1:N
  if ( (rho(i)>rhomin) && (delta(i)>deltamin))
     NC = NC + 1;
     Y0(i) = NC;
     centers = [centers;i];
  end
end

for i = 1:N
    [~,Y0(i)] = min(d(i,centers));
end
Y = Y0;


rho_cut = zeros(NC,1);
for i = 1:N
    for j = i+1:N
        if(d(i,j)<=dc && Y0(i)~=Y0(j))
            rho_cut_new = (rho(i)+rho(j))/2;
            if(rho_cut_new>rho_cut(Y0(i)))
                rho_cut(Y0(i)) = rho_cut_new;
            end
            if(rho_cut_new>rho_cut(Y0(j)))
                rho_cut(Y0(j)) = rho_cut_new;
            end
        end
    end
end
for i = 1:N
    if(rho(i) < rho_cut(Y0(i)))
        Y(i) = 0;
    end
end

end

