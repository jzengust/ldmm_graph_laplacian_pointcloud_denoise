function [X] = read_ply_only_points(filename)

fid = fopen(filename, 'r');

tline = fgetl(fid);
while (isempty(strfind(tline, 'end_header')))
    tline = fgetl(fid);
    if (~isempty(strfind(tline, 'element vertex ')))
        N = str2double(tline(16:end));
    end
end

x = fscanf(fid, '%f %f %f\n');
X = reshape(x, 3, N)';

fclose(fid);

end