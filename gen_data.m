m=600; %num of address
n=10; %num of identity
average_input = 2;
average_output = 1;
shadow_probablity = 0.9;

address=1:m;
identities=1:n;
label(:,1)=randperm(m);
label(:,2)=round(rand(m,1)*(n-1))+1;
[label(:,1) label_order] = sort(label(:,1),'ascend');
label(:,2)=label(label_order,2);

% label = [label; m+1,n+1];
% function addrs = get_addr_with_id(label,id)
%     return label(label(:,2)==id),1);
% end

used_addrs=zeros(m,1);
tr={};
while true
    for i = 1:n
        own_addr = address(~used_addrs & label(:,2)==i);

        input_num = min(length(own_addr),round(rand()*average_input*2)+1);

        ti_select = randperm(length(own_addr));

        input_addrs = own_addr(ti_select(1:input_num));

        used_addrs(input_addrs) = 1;

        other_users_addr = address(label(:,2)~=i);

        to_select = randperm(length(other_users_addr));

        output_num = round(rand()*average_output*2)+1;

        output_addrs = other_users_addr(to_select(1:output_num));

        shadow_addrs_num = min(1, length(own_addr) - input_num);

        if shadow_addrs_num > 0 && rand()<shadow_probablity
            output_addrs = [output_addrs, own_addr(ti_select(input_num+1))];
        end
        tr{end+1} = input_addrs;
        tr{end+1} = output_addrs;
    end
    if sum(used_addrs) == m
        break
    end
end

%%
%begin cluster
% clustered_label = zeros(m,m);
% for i = 1:2:length(tr)
%     input_addr = tr{i};
%     output_addr = tr{i+1};
%     for x=1:length(input_addr)-1
%         for y=x:length(input_addr)
%             clustered_label(input_addr(x),input_addr(y))=1;
%             clustered_label(input_addr(y),input_addr(x))=1;
%         end
%     end
%     for x=input_addr
%         for y=output_addr
%             clustered_label(x,y) = clustered_label(x,y)+0.1;
%         end
%     end
% end
% XY = [clustered_label, label(:,2)];

