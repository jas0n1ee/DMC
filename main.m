gen_data
m=m_tol;
input_tr = zeros(m,1);

for i = 1:2:length(tr)
    for j = tr{i}
        input_tr(j) = (i+1)/2;
    end
end
total_tr = length(tr)/2;
P = eye(total_tr);

for i = 1:total_tr
    output = tr{2*i};
    for o = output
        if o<=m && input_tr(o) % o is shadow
            P(i,input_tr(o)) = 1;
            P(input_tr(o),i) = 1;
        end
    end
end

for i = 1:total_tr
    P(i,:) = P(i,:)/sum(P(i,:));
end
P = 1./(P^100);
[ NC,centers,Y,Y0] = my_cluster( P );

cluster_result = zeros(m,1);
for i = 1:total_tr
    for input = tr{2*i-1}
        cluster_result(input) = Y0(i);
    end
end

for i=1:max(cluster_result)
    cluster_index = mode(label(cluster_result==i,end));
    TP = (cluster_result == i) & (label(:,end)==cluster_index);
    FP = (cluster_result == i) & (label(:,end)~=cluster_index);
    TN = (cluster_result ~= i) & (label(:,end)~=cluster_index);
    FN = (cluster_result ~= i) & (label(:,end)==cluster_index);
    disp(sprintf('[Cluster %d]: Recall rate : %.2f  Precision rate: %.2f',i,sum(TP)/(sum(TP)+sum(FN)),sum(TP)/(sum(TP)+sum(FP))));
end