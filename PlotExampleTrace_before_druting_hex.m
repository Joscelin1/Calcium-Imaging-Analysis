load('P:\Calcium Imaging\SHRWKY\New Analysis 19.08.2021\WKY\21-04-08_02\21-04-08(00010)_df.mat')
dfs_before = dfs;
load('P:\Calcium Imaging\SHRWKY\New Analysis 19.08.2021\WKY\21-04-08_02\21-04-08(00013)_df.mat')
dfs_hex = dfs;

cell = 9;
hold on
plot(dfs_before(cell,:))
plot(dfs_hex(cell,:))
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