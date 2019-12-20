function [] = write_ply_only_points(X, filename)

fid = fopen(filename, 'w');

fprintf(fid, 'ply\n');
fprintf(fid, 'format ascii 1.0\n');
fprintf(fid, 'element vertex %d\n', size(X, 1));
fprintf(fid, 'property float x\n');
fprintf(fid, 'property float y\n');
fprintf(fid, 'property float z\n');
fprintf(fid, 'end_header\n');
fprintf(fid, '%f %f %f\n', X');

fclose(fid);

end