close all
clear
%%
m_ini=60;  %num of initial address
m_tol=600; %num of total target address
nxt_avil_addr = m_ini+1;
n=10; %num of identity

%%
average_input = 2;
average_output = 1;
shadow_probablity = 0.99;
pub_to_group_ratio = 1000;
auto_getnewaddress_p = 0.3;
do_nothing_p = 0.3;

%%
address=1:m_tol;
identities=1:n;
label=zeros(m_tol,2);
label(1:m_ini,1)=randperm(m_ini);
label(1:m_ini,2)=round(rand(m_ini,1)*(n-1))+1;
[label(1:m_ini,1) label_order] = sort(label(1:m_ini,1),'ascend');
label(1:m_ini,2)=label(label_order,2);

used_addrs=zeros(m_tol,1);
tr={};
%%
while true
    for i = 1:n
        if rand() < auto_getnewaddress_p && nxt_avil_addr <= m_tol
            label(nxt_avil_addr,2) = i;         % assign a new non-used addr to i
            nxt_avil_addr = nxt_avil_addr+1;
        end
        if rand() < do_nothing_p
            continue
        end
        own_addr = address(~used_addrs & label(:,2)==i);
        if length(own_addr) == 0 
            continue;
        end
        input_num = min(length(own_addr),round(rand()*average_input*2)+1);

        ti_select = randperm(length(own_addr));

        input_addrs = own_addr(ti_select(1:input_num));

        used_addrs(input_addrs) = 1;

        other_users_addr = [address(~used_addrs & label(:,2)~=i), m_tol+1:m_tol*pub_to_group_ratio]; %Allow address in set m transfer to outside address

        to_select = randperm(length(other_users_addr));

        output_num = round(rand()*average_output*2)+1;

        output_addrs = other_users_addr(to_select(1:output_num));

        shadow_addrs_num = min(1, length(own_addr) - input_num);

        if rand()<shadow_probablity && nxt_avil_addr <= m_tol
            output_addrs = [output_addrs, nxt_avil_addr];
            label(nxt_avil_addr,2) = i;         % assign a new non-used addr to i
            nxt_avil_addr = nxt_avil_addr+1;
        end
        tr{end+1} = input_addrs;
        tr{end+1} = output_addrs;
    end
    if sum(used_addrs) == m_tol 
        break;
    end
end

%%
% %gen transaction graph
% 
% figure(1)
% hold on
% w = floor(sqrt(m));
% h = ceil(m/w);
% for i = 1:2:length(tr)
%     input_addr = tr{i};
%     output_addr = tr{i+1};
%     for a = input_addr
%         for b = output_addr
%             x_a = mod(a-1,w)+1;
%             y_a = ceil(a/w);
%             x_b = mod(b-1,w)+1;
%             y_b = ceil(b/w);
%             plot([x_a,x_b],[y_a,y_b])
%         end
%     end
% end
% %%
% begin cluster
transaction_label=zeros(m_tol,1);
for i = 1:2:length(tr)
    input_addr = tr{i};
    output_addr = tr{i+1};
    for x=input_addr
        transaction_label(x) = transaction_label(x) + 1;
    end
    for x=output_addr(output_addr<m_tol)
        transaction_label(x) = transaction_label(x) + 0.1;
    end
end
%XY = [clustered_label, label(:,2)];


