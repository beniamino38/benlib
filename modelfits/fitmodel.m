function result = fitmodel(fp, data, fitset, predset)

res = struct;
for ii = 1:fp.restarts % n restarts with different initial conditions
  
  % starting values
  for jj = 1:length(fp.x0fun)
    res(ii).x0(jj) = fp.x0fun{jj}();
  end
  
  % do fitting
  res(ii).params = fmincon(@(x) ...
          sum((fp.model(x,fitdata)-fitdata.y_t).^2), ...
          res(ii).x0, fp.params{:}, fp.options);
  res(ii).yhat = fp.model(res(ii).params, fitdata);
  res(ii).sqerr = sum((res(ii).yhat-fitdata.y_t).^2);
  t = corrcoef(res(ii).yhat, fitdata.y_t);
  res(ii).fitcc = t(1,2);

  % progress bar
  if mod(ii,ceil(fp.restarts/10))==0
    fprintf('.');
  end

end

fprintf('\n');

% choose the best of the n restarts
sqerr = [res(:).sqerr];
f = find(sqerr==min(sqerr), 1);
result.params = res(f).params;
result.fit.yhat = res(f).yhat;
result.fit.sqerr = res(f).sqerr;
result.fit.cc = res(f).fitcc;

if nargin==3
  result.pred.yhat = fp.model(result.params, preddata);
  result.pred.sqerr = sum((result.pred.yhat-preddata.y_t).^2);
  t = corrcoef(result.pred.yhat, preddata.y_t);
  result.pred.cc = t(1,2);
end

result.restarts = res;
