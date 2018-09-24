
function [T,Q,U,zsol,Z,par,nit,normS] = getdata(file)

  fid = fopen(file,'r');
  line1 = fgetl(fid);
  q0 = fscanf(fid,' # q0 = %g %g %g %g %g %g %g',[7 1]);
  qf = fscanf(fid,' # qf = %g %g %g %g %g %g',[6 1]);
  free_t = fscanf(fid,' # free_t0, free_tf = %d %d',[2 1]);
  free_t0 = free_t(1); free_tf = free_t(2);
  nz = 11;
  if (free_t0 == 1)
    nz = nz + 1;
  end
  if (free_tf == 1)
    nz = nz + 1;
  end
  par = fscanf(fid,' # par = %g %g %g %g %g %g %g',[7 1]);
  mu = fscanf(fid,' # mu = %g',[1 1]);
  dist_syst = fscanf(fid,' # dist_syst = %g',[1 1]);
  period_syst = fscanf(fid,' # period_syst = %g',[1 1]);
  time_syst = fscanf(fid,' # time_syst = %g',[1 1]);
  speed_syst = fscanf(fid,' # speed_syst = %g',[1 1]);
  nit = fscanf(fid,' # nit = %d %d %d %d %d',[5 1]);
  form_z = ''; for i = 1:nz; form_z = [form_z ' %g']; end
  zsol = fscanf(fid,[' # z = ' form_z],[nz 1]);
  S = fscanf(fid,[' # S = ' form_z],[nz 1]);
  normS = fscanf(fid,' # |S| = %g',[1 1]);
  s = fscanf(fid,' # %s',[1 1]);
  form = ''; for i = 1:21, form = [form ' %g']; end;
  data = fscanf(fid,form,[18 inf]);
  fclose(fid);
  
  T = data(1,:);
  Q = data(2:8,:);
  Z = data(9:15,:);
  U = data(16:18,:);
