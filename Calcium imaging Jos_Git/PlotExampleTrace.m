load('P:\Calcium Imaging\SHRWKY\New Analysis 19.08.2021\WKY\20-11-24_01\21-03-23(00004)_df.mat')
hold on
% for i = 5:size(dfs, 2);
% plot(dfs(i, :));
% pause(0.2);
% end

% hold on

dfs_SHR = [];
dfs_SHR = dfs;

load('P:\Calcium Imaging\SHRWKY\New Analysis 19.08.2021\WKY\21-04-08_01\21-04-08(00003)_df.mat')
% for i = 5:size(dfs, 2);
% plot(dfs(i, :));
% pause(0.2);
% end

hold on
plot(dfs_SHR(12, 500:1000), 'r');
plot(dfs(6, 500:1000), 'b');