
 mphlaunch(model22)
function out = model22
%
% sca2d2.m
%
% Model exported on Feb 3 2026, 12:00 by COMSOL 6.2.0.339.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('C:\Users\user\Documents\Arseniy\SWITCHING_V2\COMSOL');

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 2);

model.component('comp1').mesh.create('mesh1');

model.component('comp1').physics.create('ewfd', 'ElectromagneticWavesFrequencyDomain', 'geom1');

model.component('comp1').geom('geom1').run;
model.component('comp1').geom('geom1').create('c1', 'Circle');

model.param.set('sizePar', '2');
model.param.set('N', '20');
model.param.set('nrfer0', '2');
model.param.set('lambda', '2*pi* 1[m] / sizePar');
model.param.set('maxR', 'sizePar * ceil(sqrt(N)) * 3');

model.component('comp1').geom('geom1').feature('c1').set('r', 'maxR');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('c1').set('r', 'maxR +1.5* sizeP');
model.component('comp1').geom('geom1').feature('c1').setIndex('layer', '1.5* sizeP', 0);
model.component('comp1').geom('geom1').run('');
model.component('comp1').geom('geom1').feature('c1').set('r', 'maxR +1.5 * sizePar');
model.component('comp1').geom('geom1').feature('c1').setIndex('layer', '1.5* sizePar', 0);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('c1').setIndex('layer', '1* sizePar', 0);
model.component('comp1').geom('geom1').feature('c1').set('r', 'maxR +1 * sizePar');
model.component('comp1').geom('geom1').runPre('fin');

N = 16; r = 0.65;
addpath('C:\Users\user\Documents\Arseniy\new\SWITCHING_V2\SWITCHING_V2');
init_coord = cell2mat(startPosition(N, 4*r));
params = load('params5.mat');
N = (length(params.optimal_params) + 2)/3;
r = 0.65;

radii = r * (1 + params.optimal_params(1:N));
init = startPosition(N, 4*r);
c = r * params.optimal_params(N+1:end);
coords = cell2mat(init).' + r * reshape([0; 0; c], [2, N]).';

lmbd = 1.55; %um
radii = radii * lmbd / 2 / pi;
coords = coords * lmbd / 2 / pi;
for n = 1:N
    name = sprintf('c%d', n+1);
    model.component('comp1').geom('geom1').create(name, 'Circle');
    model.component('comp1').geom('geom1').feature(name).set('r', radii(n));
    model.component('comp1').geom('geom1').feature(name).set('pos', coords(n, :));
end
model.component('comp1').geom('geom1').runPre('fin');

out = model;

end
