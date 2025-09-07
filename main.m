function main()
% MAIN  Interactive infinite-looking grid viewer with orbit camera.
% Run by calling `main` in MATLAB.

% Parameters
gridSpacing = 1;          % minor grid spacing
majorEvery  = 5;          % highlight every Nth line
gridRadius  = 150;        % draw radius around pivot
checkerTile = 2;          % tile size for checker texture
checkerColors = [0.92 0.92 0.92; 0.76 0.76 0.76]; % two tile colors

% Camera state
camState.az = -30; camState.el = 25; camState.dist = 60; camState.pivot = [0 0 0];

% Interaction
isDragging = false; dragButton = ''; lastPoint = [0 0];

% Create figure and axes
fig = figure('Name','Infinite Grid Explorer','NumberTitle','off', ...
	'Color',[0.94 0.94 0.94], 'MenuBar','none','ToolBar','none', ...
	'WindowButtonDownFcn',@mouseDown, 'WindowButtonUpFcn',@mouseUp, ...
	'WindowButtonMotionFcn',@mouseMove, 'WindowScrollWheelFcn',@scrollWheel, ...
	'KeyPressFcn',@keyPress);

ax = axes('Parent',fig); hold(ax,'on'); axis(ax,'equal'); view(ax,3); box(ax,'on');
xlabel(ax,'X'); ylabel(ax,'Y'); zlabel(ax,'Z'); set(ax,'Projection','perspective');
set(ax,'XLimMode','manual','YLimMode','manual','ZLimMode','manual');
try
	set(fig,'Renderer','opengl');
catch
	% ignore if renderer setting not supported
end

% Ground surface (textured checker) - lower resolution for interactive speed
surfRes = 256;
checkerImage = makeCheckerImage(surfRes, checkerTile, gridRadius, checkerColors);
groundSurf = surface(ax, [-gridRadius gridRadius], [-gridRadius gridRadius], [0 0; 0 0], ...
	function main()
	% MAIN  Interactive infinite-looking grid viewer with orbit camera.

	% Parameters
	gridSpacing = 1;          % minor grid spacing
	majorEvery  = 5;          % highlight every Nth line
	gridRadius  = 150;        % draw radius around pivot
	checkerTile = 2;          % tile size for checker texture
	checkerColors = [0.92 0.92 0.92; 0.76 0.76 0.76]; % two tile colors

	% Camera state
	camState.az = -30; camState.el = 25; camState.dist = 60; camState.pivot = [0 0 0];

	% Interaction
	isDragging = false; dragButton = ''; lastPoint = [0 0];

	% Create figure and axes
	fig = figure('Name','Infinite Grid Explorer','NumberTitle','off', ...
		'Color',[0.94 0.94 0.94], 'MenuBar','none','ToolBar','none', ...
		'WindowButtonDownFcn',@mouseDown, 'WindowButtonUpFcn',@mouseUp, ...
		'WindowButtonMotionFcn',@mouseMove, 'WindowScrollWheelFcn',@scrollWheel, ...
		'KeyPressFcn',@keyPress);

	ax = axes('Parent',fig); hold(ax,'on'); axis(ax,'equal'); view(ax,3); box(ax,'on');
	xlabel(ax,'X'); ylabel(ax,'Y'); zlabel(ax,'Z'); set(ax,'Projection','perspective');
	set(ax,'XLimMode','manual','YLimMode','manual','ZLimMode','manual');
	try set(fig,'Renderer','opengl'); catch; end

	% Ground surface (texture)
	surfRes = 256;
	checkerImage = makeCheckerImage(surfRes, checkerTile, gridRadius, checkerColors);
	groundSurf = surface(ax, [-gridRadius gridRadius], [-gridRadius gridRadius], [0 0; 0 0], ...
		'CData',checkerImage, 'FaceColor','texturemap', 'EdgeColor','none');

	% Grouped lines for performance
	minorX = plot3(ax, nan, nan, nan, 'Color',[0 0 0 0.12]);
	minorY = plot3(ax, nan, nan, nan, 'Color',[0 0 0 0.12]);
	majorX = plot3(ax, nan, nan, nan, 'Color',[0 0 0 0.28],'LineWidth',1.0);
	majorY = plot3(ax, nan, nan, nan, 'Color',[0 0 0 0.28],'LineWidth',1.0);

	% Pivot marker
	pivotMarker = plot3(ax,0,0,0,'ro','MarkerFaceColor','r','MarkerSize',6);

	% Initial draw
	updateCamera(); drawGrid(); updateAxesLimits();

		function updateCamera()
			camState.el = max(min(camState.el,89.9),-89.9);
			cx = cosd(camState.el)*cosd(camState.az);
			cy = cosd(camState.el)*sind(camState.az);
			cz = sind(camState.el);
			camPos = camState.pivot + camState.dist * [cx cy cz];
			campos(ax, camPos); camtarget(ax, camState.pivot); camup(ax,[0 0 1]);
		end

		function drawGrid()
			px = camState.pivot(1); py = camState.pivot(2);
			xMin = px - gridRadius; xMax = px + gridRadius;
			yMin = py - gridRadius; yMax = py + gridRadius;

			% X-aligned lines (vary Y)
			ys = (ceil(yMin/gridSpacing)-1:gridSpacing:floor(yMax/gridSpacing)+1);
			m = numel(ys);
			Xminor2 = nan(1, m*3); Yminor2 = nan(1, m*3); Zminor2 = nan(1, m*3);
			Xmajor2 = nan(1, m*3); Ymajor2 = nan(1, m*3); Zmajor2 = nan(1, m*3);
			for ii = 1:m
				idx = (ii-1)*3 + (1:3);
				Xminor2(idx) = [xMin xMax NaN];
				Yminor2(idx) = [ys(ii) ys(ii) NaN];
				Zminor2(idx) = [0 0 NaN];
				if mod(round(ys(ii)/gridSpacing), majorEvery) == 0
					Xmajor2(idx) = Xminor2(idx); Ymajor2(idx) = Yminor2(idx); Zmajor2(idx) = Zminor2(idx);
				end
			end
			set(minorY,'XData',Xminor2,'YData',Yminor2,'ZData',Zminor2);
			set(majorY,'XData',Xmajor2,'YData',Ymajor2,'ZData',Zmajor2);

			% Y-aligned lines (vary X)
			xs = (ceil(xMin/gridSpacing)-1:gridSpacing:floor(xMax/gridSpacing)+1);
			n = numel(xs);
			Xminor = nan(1, n*3); Yminor = nan(1, n*3); Zminor = nan(1, n*3);
			Xmajor = nan(1, n*3); Ymajor = nan(1, n*3); Zmajor = nan(1, n*3);
			for ii = 1:n
				idx = (ii-1)*3 + (1:3);
				Xminor(idx) = [xs(ii) xs(ii) NaN];
				Yminor(idx) = [yMin yMax NaN];
				Zminor(idx) = [0 0 NaN];
				if mod(round(xs(ii)/gridSpacing), majorEvery) == 0
					Xmajor(idx) = Xminor(idx); Ymajor(idx) = Yminor(idx); Zmajor(idx) = Zminor(idx);
				end
			end
			set(minorX,'XData',Xminor,'YData',Yminor,'ZData',Zminor);
			set(majorX,'XData',Xmajor,'YData',Ymajor,'ZData',Zmajor);

			% Move ground surface so texture follows pivot
			set(groundSurf, 'XData', [xMin xMax], 'YData', [yMin yMax]);
			set(pivotMarker, 'XData', camState.pivot(1), 'YData', camState.pivot(2), 'ZData', camState.pivot(3));
			drawnow limitrate;
		end

		function mouseDown(~,~)
			p = get(fig,'CurrentPoint'); lastPoint = p(1,1:2);
			isDragging = true; sel = get(fig,'SelectionType');
			if strcmp(sel,'normal'), dragButton = 'left'; elseif strcmp(sel,'alt'), dragButton = 'right'; else dragButton = 'middle'; end
		end

		function mouseUp(~,~)
			isDragging = false; dragButton = '';
		end

		function mouseMove(~,~)
			if ~isDragging, return; end
			p = get(fig,'CurrentPoint'); cur = p(1,1:2); delta = cur - lastPoint; lastPoint = cur;
			switch dragButton
				case 'left'
					if norm(delta) < 0.35, return; end
					azAng = -delta(1)*0.25; elAng = delta(2)*0.25;
					camorbit(ax, azAng, elAng, 'data');
					v = view(ax); camState.az = v(1); camState.el = v(2);
				case 'right'
					cpos = campos(ax); dir = camState.pivot - cpos; dir = dir / norm(dir);
					camRight = cross([0 0 1], dir); camRight = camRight / norm(camRight);
					camForward = cross(dir, camRight); camForward = camForward / norm(camForward);
					panScale = camState.dist * 0.002;
					camState.pivot = camState.pivot + (-delta(1)*panScale)*camRight + (delta(2)*panScale)*camForward;
					updateCamera();
			end
			drawGrid();
		end

		function scrollWheel(~,ev)
			camState.dist = max(0.5, camState.dist * (1 - ev.VerticalScrollCount*0.08));
			updateCamera(); drawGrid();
		end

		function keyPress(~,ev)
			k = ev.Key; step = max(0.1, camState.dist*0.02);
			switch lower(k)
				case 'w', camState.pivot(2) = camState.pivot(2) + step;
				case 's', camState.pivot(2) = camState.pivot(2) - step;
				case 'a', camState.pivot(1) = camState.pivot(1) - step;
				case 'd', camState.pivot(1) = camState.pivot(1) + step;
				case 'q', camState.pivot(3) = camState.pivot(3) + step;
				case 'e', camState.pivot(3) = camState.pivot(3) - step;
				case 'r', camState.az = -30; camState.el = 25; camState.dist = 60; camState.pivot = [0 0 0]; updateCamera();
				case 'escape', close(fig); return;
			end
			updateCamera(); drawGrid();
		end

		function updateAxesLimits()
			lim = gridRadius*1.02; xlim(ax,[-lim lim]); ylim(ax,[-lim lim]); zlim(ax,[-lim/10 lim]);
		end

	end

	function img = makeCheckerImage(res, tileSize, radius, colors)
	% MAKECHECKERIMAGE  Create a checker texture without toolbox functions
	surfaceSize = 2*radius;
	numTiles = max(4, ceil(surfaceSize / tileSize));
	[xIdx,yIdx] = meshgrid(0:numTiles-1, 0:numTiles-1);
	small = mod(xIdx + yIdx, 2) == 0;
	img = zeros(res,res,3);
	[sx, sy] = meshgrid(linspace(1,numTiles,res), linspace(1,numTiles,res));
	idx = round(sx); idx(idx<1)=1; idx(idx>numTiles)=numTiles;
	idy = round(sy); idy(idy<1)=1; idy(idy>numTiles)=numTiles;
	for c = 1:3
		channel = colors(1,c) * ones(numTiles);
		channel(small==1) = colors(2,c);
		img(:,:,c) = channel(sub2ind([numTiles numTiles], idy, idx));
	end

	end
% Create figure and axes
fig = figure('Name','Infinite Grid Explorer','NumberTitle','off', ...
	'Color',[0.94 0.94 0.94], 'MenuBar','none','ToolBar','none', ...
	'WindowButtonDownFcn',@mouseDown, 'WindowButtonUpFcn',@mouseUp, ...
	'WindowButtonMotionFcn',@mouseMove, 'WindowScrollWheelFcn',@scrollWheel, ...
	'KeyPressFcn',@keyPress);

ax = axes('Parent',fig); hold(ax,'on'); axis(ax,'equal'); view(ax,3); box(ax,'on');
xlabel(ax,'X'); ylabel(ax,'Y'); zlabel(ax,'Z'); set(ax,'Projection','perspective');
set(ax,'XLimMode','manual','YLimMode','manual','ZLimMode','manual');
try
	set(fig,'Renderer','opengl');
catch
	% ignore if renderer setting not supported
end

% Ground surface (textured checker)
surfRes = 512;
checkerImage = makeCheckerImage(surfRes, checkerTile, gridRadius, checkerColors);
groundSurf = surface(ax, [-gridRadius gridRadius], [-gridRadius gridRadius], [0 0; 0 0], ...
	'CData',checkerImage, 'FaceColor','texturemap', 'EdgeColor','none');

% Grouped line objects for performance
minorX = plot3(ax, nan, nan, nan, 'Color',[0 0 0 0.12]);
minorY = plot3(ax, nan, nan, nan, 'Color',[0 0 0 0.12]);
majorX = plot3(ax, nan, nan, nan, 'Color',[0 0 0 0.28],'LineWidth',1.0);
majorY = plot3(ax, nan, nan, nan, 'Color',[0 0 0 0.28],'LineWidth',1.0);

% Pivot marker
pivotMarker = plot3(ax,0,0,0,'ro','MarkerFaceColor','r','MarkerSize',6);

% Initial draw
updateCamera(); drawGrid(); updateAxesLimits();

	function updateCamera()
		% compute camera pos from spherical coords and apply
		camState.el = max(min(camState.el,89.9),-89.9);
		cx = cosd(camState.el)*cosd(camState.az);
		cy = cosd(camState.el)*sind(camState.az);
		cz = sind(camState.el);
		camPos = camState.pivot + camState.dist * [cx cy cz];
		campos(ax, camPos);
		camtarget(ax, camState.pivot);
		camup(ax,[0 0 1]);
	end

	function drawGrid()
		% Recompute grid lines around pivot to appear infinite
		px = camState.pivot(1); py = camState.pivot(2);
		xMin = px - gridRadius; xMax = px + gridRadius;
		yMin = py - gridRadius; yMax = py + gridRadius;

		% X-aligned lines (vary Y) stored in minorY/majorY
		ys = (ceil(yMin/gridSpacing)-1:gridSpacing:floor(yMax/gridSpacing)+1);
		m = numel(ys);
		Xminor2 = nan(1, m*3); Yminor2 = nan(1, m*3); Zminor2 = nan(1, m*3);
		Xmajor2 = nan(1, m*3); Ymajor2 = nan(1, m*3); Zmajor2 = nan(1, m*3);
		for ii = 1:m
			idx = (ii-1)*3 + (1:3);
			Xminor2(idx) = [xMin xMax NaN];
			Yminor2(idx) = [ys(ii) ys(ii) NaN];
			Zminor2(idx) = [0 0 NaN];
			if mod(round(ys(ii)/gridSpacing), majorEvery) == 0
				Xmajor2(idx) = Xminor2(idx);
				Ymajor2(idx) = Yminor2(idx);
				Zmajor2(idx) = Zminor2(idx);
			end
		end
		set(minorY,'XData',Xminor2,'YData',Yminor2,'ZData',Zminor2);
		set(majorY,'XData',Xmajor2,'YData',Ymajor2,'ZData',Zmajor2);

		% Y-aligned lines (vary X) stored in minorX/majorX
		xs = (ceil(xMin/gridSpacing)-1:gridSpacing:floor(xMax/gridSpacing)+1);
		n = numel(xs);
		Xminor = nan(1, n*3); Yminor = nan(1, n*3); Zminor = nan(1, n*3);
		Xmajor = nan(1, n*3); Ymajor = nan(1, n*3); Zmajor = nan(1, n*3);
		for ii = 1:n
			idx = (ii-1)*3 + (1:3);
			Xminor(idx) = [xs(ii) xs(ii) NaN];
			Yminor(idx) = [yMin yMax NaN];
			Zminor(idx) = [0 0 NaN];
			if mod(round(xs(ii)/gridSpacing), majorEvery) == 0
				Xmajor(idx) = Xminor(idx);
				Ymajor(idx) = Yminor(idx);
				Zmajor(idx) = Zminor(idx);
			end
		end
		set(minorX,'XData',Xminor,'YData',Yminor,'ZData',Zminor);
		set(majorX,'XData',Xmajor,'YData',Ymajor,'ZData',Zmajor);

		% Move ground surface so texture follows pivot
		set(groundSurf, 'XData', [xMin xMax], 'YData', [yMin yMax]);
		set(pivotMarker, 'XData', camState.pivot(1), 'YData', camState.pivot(2), 'ZData', camState.pivot(3));
		drawnow limitrate;
	end

	function mouseDown(~,~)
		p = get(fig,'CurrentPoint'); lastPoint = p(1,1:2);
		isDragging = true;
		sel = get(fig,'SelectionType');
		if strcmp(sel,'normal')
			dragButton = 'left';
		elseif strcmp(sel,'alt')
			dragButton = 'right';
		else
			dragButton = 'middle';
		end
	end

	function mouseUp(~,~)
		isDragging = false; dragButton = '';
	end

	function mouseMove(~,~)
		if ~isDragging
			return;
		end
		p = get(fig,'CurrentPoint'); cur = p(1,1:2); delta = cur - lastPoint; lastPoint = cur;
		switch dragButton
			case 'left'
				% rotate with camorbit (preserves distance)
				azAng = -delta(1)*0.25; elAng = delta(2)*0.25;
				camorbit(ax, azAng, elAng, 'data');
				v = view(ax); camState.az = v(1); camState.el = v(2);
				camState.dist = norm(campos(ax) - camState.pivot);
			case 'right'
				% pan: move pivot in camera plane
				cpos = campos(ax); dir = camState.pivot - cpos; dir = dir / norm(dir);
				camRight = cross([0 0 1], dir); camRight = camRight / norm(camRight);
				camForward = cross(dir, camRight); camForward = camForward / norm(camForward);
				panScale = camState.dist * 0.002;
				camState.pivot = camState.pivot + (-delta(1)*panScale)*camRight + (delta(2)*panScale)*camForward;
				updateCamera();
		end
		drawGrid();
	end

	function scrollWheel(~,ev)
		camState.dist = max(0.5, camState.dist * (1 - ev.VerticalScrollCount*0.08));
		updateCamera(); drawGrid();
	end

	function keyPress(~,ev)
		k = ev.Key; step = max(0.1, camState.dist*0.02);
		switch lower(k)
			case 'w'
				camState.pivot(2) = camState.pivot(2) + step;
			case 's'
				camState.pivot(2) = camState.pivot(2) - step;
			case 'a'
				camState.pivot(1) = camState.pivot(1) - step;
			case 'd'
				camState.pivot(1) = camState.pivot(1) + step;
			case 'q'
				camState.pivot(3) = camState.pivot(3) + step;
			case 'e'
				camState.pivot(3) = camState.pivot(3) - step;
			case 'r'
				camState.az = -30; camState.el = 25; camState.dist = 60; camState.pivot = [0 0 0]; updateCamera();
			case 'escape'
				close(fig); return;
		end
		updateCamera(); drawGrid();
	end

	function updateAxesLimits()
		lim = gridRadius*1.02; xlim(ax,[-lim lim]); ylim(ax,[-lim lim]); zlim(ax,[-lim/10 lim]);
	end

end

function img = makeCheckerImage(res, tileSize, radius, colors)
% MAKECHECKERIMAGE  Create a checker texture without toolbox functions
surfaceSize = 2*radius;
numTiles = max(4, ceil(surfaceSize / tileSize));
[xIdx,yIdx] = meshgrid(0:numTiles-1, 0:numTiles-1);
small = mod(xIdx + yIdx, 2) == 0;
img = zeros(res,res,3);
[sx, sy] = meshgrid(linspace(1,numTiles,res), linspace(1,numTiles,res));
idx = round(sx); idx(idx<1)=1; idx(idx>numTiles)=numTiles;
idy = round(sy); idy(idy<1)=1; idy(idy>numTiles)=numTiles;
for c = 1:3
	channel = colors(1,c) * ones(numTiles);
	channel(small==1) = colors(2,c);
	img(:,:,c) = channel(sub2ind([numTiles numTiles], idy, idx));
end

end
%
lastPoint = [0 0];
				Ymajor(idx) = Yminor(idx);
				Zmajor(idx) = Zminor(idx);
			end
		end
		set(minorX,'XData',Xminor,'YData',Yminor,'ZData',Zminor);
		set(majorX,'XData',Xmajor,'YData',Ymajor,'ZData',Zmajor);

		% Lines parallel to X (vary Y)
		ys = (ceil(yMin/gridSpacing)-1:gridSpacing:floor(yMax/gridSpacing)+1);
		function main()
		% MAIN  Interactive infinite-looking grid viewer with orbit camera.
		% Run by calling `main` in MATLAB.

		% Parameters
		gridSpacing = 1;
		majorEvery  = 5;
		gridRadius  = 150;
		checkerTile = 2;
		checkerColors = [0.92 0.92 0.92; 0.76 0.76 0.76];

		% Camera state
		camState.az = -30; camState.el = 25; camState.dist = 60; camState.pivot = [0 0 0];

		% Interaction
		isDragging = false; dragButton = ''; lastPoint = [0 0];

		% Figure + axes
		fig = figure('Name','Infinite Grid Explorer','NumberTitle','off', ...
			'Color',[0.94 0.94 0.94], 'MenuBar','none','ToolBar','none', ...
			'WindowButtonDownFcn',@mouseDown, 'WindowButtonUpFcn',@mouseUp, ...
			'WindowButtonMotionFcn',@mouseMove, 'WindowScrollWheelFcn',@scrollWheel, ...
			'KeyPressFcn',@keyPress);

		ax = axes('Parent',fig); hold(ax,'on'); axis(ax,'equal'); view(ax,3); box(ax,'on');
		xlabel(ax,'X'); ylabel(ax,'Y'); zlabel(ax,'Z'); set(ax,'Projection','perspective');
		set(ax,'XLimMode','manual','YLimMode','manual','ZLimMode','manual');
		try set(fig,'Renderer','opengl'); end

		% Ground surface (textured checker)
		surfRes = 512;
		checkerImage = makeCheckerImage(surfRes, checkerTile, gridRadius, checkerColors);
		groundSurf = surface(ax, [-gridRadius gridRadius], [-gridRadius gridRadius], [0 0; 0 0], ...
			'CData',checkerImage, 'FaceColor','texturemap', 'EdgeColor','none');

		% Grouped line objects for performance
		minorX = plot3(ax, nan, nan, nan, 'Color',[0 0 0 0.12]);
		minorY = plot3(ax, nan, nan, nan, 'Color',[0 0 0 0.12]);
		majorX = plot3(ax, nan, nan, nan, 'Color',[0 0 0 0.28],'LineWidth',1.0);
		majorY = plot3(ax, nan, nan, nan, 'Color',[0 0 0 0.28],'LineWidth',1.0);

		% Pivot marker
		pivotMarker = plot3(ax,0,0,0,'ro','MarkerFaceColor','r','MarkerSize',6);

		% Initial draw
		updateCamera(); drawGrid(); updateAxesLimits();

			function updateCamera()
				% compute camera pos from spherical coords and apply
				el = max(min(camState.el,89.9),-89.9); camState.el = el;
				cx = cosd(el)*cosd(camState.az); cy = cosd(el)*sind(camState.az); cz = sind(el);
				camPos = camState.pivot + camState.dist * [cx cy cz];
				campos(ax, camPos); camtarget(ax, camState.pivot); camup(ax,[0 0 1]);
			end

			function drawGrid()
				px = camState.pivot(1); py = camState.pivot(2);
				xMin = px - gridRadius; xMax = px + gridRadius;
				yMin = py - gridRadius; yMax = py + gridRadius;

				% X-aligned lines (vary Y) are stored in minorY/majorY
				ys = (ceil(yMin/gridSpacing)-1:gridSpacing:floor(yMax/gridSpacing)+1);
				m = numel(ys);
				Xminor2 = nan(1, m*3); Yminor2 = nan(1, m*3); Zminor2 = nan(1, m*3);
				Xmajor2 = nan(1, m*3); Ymajor2 = nan(1, m*3); Zmajor2 = nan(1, m*3);
				for ii=1:m
					idx = (ii-1)*3 + (1:3);
					Xminor2(idx) = [xMin xMax NaN];
					Yminor2(idx) = [ys(ii) ys(ii) NaN];
					Zminor2(idx) = [0 0 NaN];
					if mod(round(ys(ii)/gridSpacing), majorEvery) == 0
						Xmajor2(idx) = Xminor2(idx); Ymajor2(idx) = Yminor2(idx); Zmajor2(idx) = Zminor2(idx);
					end
				end
				set(minorY,'XData',Xminor2,'YData',Yminor2,'ZData',Zminor2);
				set(majorY,'XData',Xmajor2,'YData',Ymajor2,'ZData',Zmajor2);

				% Y-aligned lines (vary X) stored in minorX/majorX
				xs = (ceil(xMin/gridSpacing)-1:gridSpacing:floor(xMax/gridSpacing)+1);
				n = numel(xs);
				Xminor = nan(1, n*3); Yminor = nan(1, n*3); Zminor = nan(1, n*3);
				Xmajor = nan(1, n*3); Ymajor = nan(1, n*3); Zmajor = nan(1, n*3);
				for ii=1:n
					idx = (ii-1)*3 + (1:3);
					Xminor(idx) = [xs(ii) xs(ii) NaN];
					Yminor(idx) = [yMin yMax NaN];
					Zminor(idx) = [0 0 NaN];
					if mod(round(xs(ii)/gridSpacing), majorEvery) == 0
						Xmajor(idx) = Xminor(idx); Ymajor(idx) = Yminor(idx); Zmajor(idx) = Zminor(idx);
					end
				end
				set(minorX,'XData',Xminor,'YData',Yminor,'ZData',Zminor);
				set(majorX,'XData',Xmajor,'YData',Ymajor,'ZData',Zmajor);

				% Move ground surface so texture follows pivot
				set(groundSurf, 'XData', [xMin xMax], 'YData', [yMin yMax]);
				set(pivotMarker, 'XData', camState.pivot(1), 'YData', camState.pivot(2), 'ZData', camState.pivot(3));
				drawnow limitrate
			end

			function mouseDown(~,~)
				lastPoint = get(fig,'CurrentPoint'); lastPoint = lastPoint(1,1:2);
				isDragging = true; sel = get(fig,'SelectionType');
				if strcmp(sel,'normal'), dragButton='left'; elseif strcmp(sel,'alt'), dragButton='right'; else dragButton='middle'; end
			end

			function mouseUp(~,~)
				isDragging = false; dragButton='';
			end

			function mouseMove(~,~)
				if ~isDragging, return; end
				cur = get(fig,'CurrentPoint'); cur = cur(1,1:2); delta = cur - lastPoint; lastPoint = cur;
				switch dragButton
					case 'left'
						azAng = -delta(1)*0.25; elAng = delta(2)*0.25;
						camorbit(ax, azAng, elAng, 'data');
						v = view(ax); camState.az = v(1); camState.el = v(2);
						camState.dist = norm(campos(ax) - camState.pivot);
					case 'right'
						% Pan: move pivot in camera plane
						cpos = campos(ax); dir = camState.pivot - cpos; dir = dir / norm(dir);
						camRight = cross([0 0 1], dir); camRight = camRight / norm(camRight);
						camForward = cross(dir, camRight); camForward = camForward / norm(camForward);
						panScale = camState.dist * 0.002;
						camState.pivot = camState.pivot + (-delta(1)*panScale)*camRight + (delta(2)*panScale)*camForward;
						updateCamera();
				end
				drawGrid();
			end

			function scrollWheel(~,ev)
				camState.dist = max(0.5, camState.dist * (1 - ev.VerticalScrollCount*0.08));
				updateCamera(); drawGrid();
			end

			function keyPress(~,ev)
				k = ev.Key; step = max(0.1, camState.dist*0.02);
				switch lower(k)
					case 'w', camState.pivot(2)=camState.pivot(2)+step;
					case 's', camState.pivot(2)=camState.pivot(2)-step;
					case 'a', camState.pivot(1)=camState.pivot(1)-step;
					case 'd', camState.pivot(1)=camState.pivot(1)+step;
					case 'q', camState.pivot(3)=camState.pivot(3)+step;
					case 'e', camState.pivot(3)=camState.pivot(3)-step;
					case 'r', camState.az=-30; camState.el=25; camState.dist=60; camState.pivot=[0 0 0]; updateCamera();
					case 'escape', close(fig); return
				end
				updateCamera(); drawGrid();
			end

			function updateAxesLimits()
				lim = gridRadius*1.02; xlim(ax,[-lim lim]); ylim(ax,[-lim lim]); zlim(ax,[-lim/10 lim]);
			end

		end

		function img = makeCheckerImage(res, tileSize, radius, colors)
		% Create a simple procedural checker texture without toolboxes
		surfaceSize = 2*radius;
		numTiles = max(4, ceil(surfaceSize / tileSize));
		[xIdx,yIdx] = meshgrid(0:numTiles-1, 0:numTiles-1);
		small = mod(xIdx + yIdx, 2) == 0;
		img = zeros(res,res,3);
		[sx, sy] = meshgrid(linspace(1,numTiles,res), linspace(1,numTiles,res));
		idx = round(sx); idx(idx<1)=1; idx(idx>numTiles)=numTiles;
		idy = round(sy); idy(idy<1)=1; idy(idy>numTiles)=numTiles;
		for c=1:3
			channel = colors(1,c) * ones(numTiles); channel(small==1) = colors(2,c);
			img(:,:,c) = channel(sub2ind([numTiles numTiles], idy, idx));
		end

		end
			case 'a'

				camState.pivot(1:2) = camState.pivot(1:2) + [-moveStep 0];
