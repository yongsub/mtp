

function mex_compile(debugging)

str = {
	'mex cpp/mex_GlueOthers_Greedy.cpp -largeArrayDims -outdir cpp'...
	'mex cpp/mex_MoveForBalance.cpp -largeArrayDims -outdir cpp'...
};
if exist('debugging', 'var') && debugging
	for i=1:length(str)
		str{i} = [str{i} ' -g'];
	end
end


for i=1:length(str)
	fprintf([str{i} '\n'])
	eval(str{i})
end

end