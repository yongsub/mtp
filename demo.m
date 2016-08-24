

% metis-5.1.0 is the root directory of the METIS library.
% metismex is the root directory of its interface metismex.

clear;

addpath cpp;
addpath metis-5.1.0/metismex;

load data/advogato.mat;

if ~exist('result', 'dir')
	mkdir('result');
end

% 1: run MTP
% 0: run gbMTP

mtpDemo = 0;

if mtpDemo	
	range = 0:100;
	
	gccconds = zeros(length(range),1);
	gccsizes = zeros(length(range),1);
	
	fprintf('For the advogato graph data, MTP runs on k from 0 to 0.1n.\n');
	
	for i=range
		
		k = i * 0.001;
		tic;
		[label, cond] = MTP(W, k, 0);
		elapsed = toc;
		
		fprintf('== Running with k=%.3f takes %.4f seconds.\n', k, elapsed);
		
		gccsizes(i+1) = nnz(label>0);
		gccconds(i+1) = cond(1);
		
	end
	
	
	dlmwrite('result/demo_MTP.out', [gccconds gccsizes], 'delimiter', '\t');
	
	ax = plotyy(range*0.001, gccconds, range*0.001, gccsizes/max(gccsizes));
	set(ax(1),'ylim',[0 max(gccconds)]);
	set(ax(2),'ylim',[0 1], 'ytick', 0:0.5:1);
else
	range = 0:100;
	
	gccconds = zeros(length(range),1);
	gccsizes = zeros(length(range),1);
	
	fprintf('For the advogato graph data, gbMTP runs on k from 0 to 100.\n');
	
	for i=range
		
		k = i;
		tic;
		[label, cond] = MTP(W, k, 1);
		elapsed = toc;
		
		fprintf('== Running with k=%.3f takes %.4f seconds.\n', k, elapsed);
		
		gccsizes(i+1) = nnz(label>0);
		gccconds(i+1) = cond(2);
		
	end
	
	
	dlmwrite('result/demo_gbMTP.out', [gccconds gccsizes], 'delimiter', '\t');
	
	ax = plotyy(range*0.001, gccconds, range*0.001, gccsizes/max(gccsizes));
	set(ax(1),'ylim',[0.24 0.45], 'ytick', 0:0.1:0.4);
	set(ax(2),'ylim',[0 1], 'ytick', 0:0.5:1);
end