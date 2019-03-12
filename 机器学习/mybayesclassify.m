function [class,posteriori] = mybayesclassify(model,data)
%MYBAYECLASSIFY - Classify by Bayes classifier
%
%   class = mybayesclassify(model,test)
%   [class,posteriori] = mybayesclassify(model,test)

%% 参数检查
narginchk(2,2);
nargoutchk(0,2);

%% 获取参数
table = model.table; %样本结构体的引索表
nclass = numel(table.classset); %类别数量
nfeature = numel(table.featureset); %特征数量
probability = model.probability; %先验概率和条件概率

%% 计算后验概率
%遍历类别
posteriori = zeros(nclass,1);
for i=1:nclass
    posteriori(i) = probability{i,1}; %先验概率
    %遍历特征
    for j=1:nfeature
        value = data.feature{j};
        valueset = table.featureset{j};
        if ischar(value) %字符串
            index = find(strcmp(value,valueset));
        else %数字
            index = find(value == cell2mat(valueset));
        end
        posteriori(i) = posteriori(i)*probability{i,j+1}(index); %条件概率
    end
end
posteriori = posteriori/sum(posteriori);
%取概率最大的类别
[~,index] = max(posteriori);
class = table.classset{index};


