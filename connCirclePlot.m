classdef connCirclePlot < handle
% connCirclePlot Plot creates a circular graph to illustrate connections/connectivity in a network.
%
%% Syntax
% connCirclePlot(X)
% connCirclePlot(X,'PropertyName',propertyvalue,...)
% h = connCirclePlot(...)
%
%
% Required input arguments.
% X : A symmetric matrix of numeric or logical values.
%
% Optional properties.
% Label   : A cell array of N strings.
% MinVal  : A numeric value for the min value for the linewidth and colorbar.
% MaxVal  : A numeric value for the max value for the linewidth and colorbar.
% TextSize: A numeric value for the min value for the text size of the
% labels.
% MaxLineThickness  : A numeric value for the max thickness the lines.
% ShowColorbar: Boolean value that indicates whether to show the colorbar.
% CurvedLines: Boolean value that indicates whether to plot a curve or a
% line.
%%
% Author: Jan-Luca Schröder (2023)

    properties
        Label;            % Cell array of strings
        MaxVal;           % Numeric value
        MinVal;           % Numeric value
        ShowColorbar;     % Boolean value
        TextSize;         % Numeric value
        MaxLineThickness; % Numeric value  
        CurvedLines;      % Boolean value
    end

    methods
        function this = connCirclePlot(adjacencyMatrix,varargin)

            p = inputParser;

            % load colourmap
            load('./', 'rbw_cmap');
            
            % set default label
            defaultLabel = cell(length(adjacencyMatrix),1);
            for i = 1:length(defaultLabel)
                defaultLabel{i} = num2str(i);
            end

            % turn on colorbar by default
            defaultShowColorbar = true;
            
            % curve lines by defaults
            defaultCurvedLines = true;

            % set default min and max values for colormap
            defaultMin = -1;
            defaultMax = 1;
            
            defaultTextSize = 8;
            defaultLineWidth = 2;

            addRequired(p,'adjacencyMatrix',@(x)(isnumeric(x) || islogical(x)));
            addParameter(p,'Label' ,defaultLabel ,@iscell);
            addParameter(p,'MinVal' ,defaultMin ,@isnumeric);
            addParameter(p,'MaxVal' ,defaultMax ,@isnumeric);
            addParameter(p,'ShowColorbar' ,defaultShowColorbar ,@islogical);
            addParameter(p,'TextSize' ,defaultTextSize ,@isnumeric);
            addParameter(p,'MaxLineThickness' ,defaultLineWidth ,@isnumeric);
            addParameter(p,'CurvedLines' ,defaultCurvedLines ,@islogical);
            
            parse(p,adjacencyMatrix,varargin{:});

            this.Label      = p.Results.Label;
            this.MinVal     = p.Results.MinVal;
            this.MaxVal     = p.Results.MaxVal;
            this.TextSize   = p.Results.TextSize;
            this.ShowColorbar     = p.Results.ShowColorbar;
            this.MaxLineThickness = p.Results.MaxLineThickness;
            this.CurvedLines    = p.Results.CurvedLines;


            theta=linspace(0,2*pi,length(adjacencyMatrix)+1);
            theta=theta(1:end-1);
            [x,y]=pol2cart(theta,1);

            % links=triu(round(rand(length(theta)))); % this is a random list of connections
            [ind1,ind2]=ind2sub(size(adjacencyMatrix),find(adjacencyMatrix(:)));

       
            % [minDistance, indexOfMin] = min(abs(colourmap-adjacencyMatrix(1,3)));
            
            % plot nodes
            plot(x,y,'.k','markersize',20, 'Color', [0.5 0.5 0.5]);hold on

            % [minDistance, indexOfMin] = min(abs(V-N));

            % add labels to the nodes
             % add labels to the nodes
            for i =1:length(x)
                offset = 0.03;
                xText = x(i) + x(i)*offset;
                yText = y(i) + y(i)*offset;
                % move text to make it more readable
                t = text(x(i),y(i),("  "+this.Label{i}), 'FontSize',this.TextSize, 'Position', [xText, yText]);
             
                % set text angle
                angle = atan2(y(i),x(i)) * 180/pi;
                set(t,'Rotation',angle);
            end

            % define colormap and its indices
            stepSize = (this.MaxVal-this.MinVal)/63;
            colourmap = this.MinVal:stepSize:this.MaxVal;

            % define cell for line width to take values from
            maxWidth = this.MaxLineThickness;
            minWidth = 0.05;
            widthStep = (maxWidth-minWidth)/63;
            lineWidthBar = minWidth:widthStep:maxWidth;

%             r  = sqrt(x0^2 + y0^2 - 1);
%             r = 1;

            for i= 1:length(ind1)
                % compare indices to colormap
                [~, indexOfMin] = min(abs(colourmap-adjacencyMatrix(ind1(i),ind2(i))));
                colVal = rbw_cmap(indexOfMin,:);
                % set linewidth based on limits
                lineWdt = lineWidthBar(indexOfMin);
                
                % draw line or curve
                if this.CurvedLines
                    % end points
                    X = [x(ind1(i)) x(ind2(i))];
                    Y = [y(ind1(i)) y(ind2(i))];
                    % intermediate point
                    Xi = mean([x(ind1(i)) x(ind2(i))]) - 0.2*mean([x(ind1(i)) x(ind2(i))]);
                    Yi = mean([y(ind1(i)) y(ind2(i))]) - 0.2*mean([y(ind1(i)) y(ind2(i))]);
                    
                    % create new 3-coord point
                    Xa = [x(ind1(i)) Xi x(ind2(i))];
                    Ya = [y(ind1(i)) Yi y(ind2(i))];
                    
                    % create grided steps in line
                    t  = 1:numel(Xa);
                    ts = linspace(min(t),max(t),numel(Xa)*10);
                    xx = spline(t,Xa,ts);
                    yy = spline(t,Ya,ts);
                    
                    % plot curve
                    plot(xx,yy,...
                        'Color', colVal,...
                        'LineWidth', lineWdt); hold on; % curve
%                     plot(Xi,Yi,'xr')      % intermediate point

                else
                    % plot line
                    line([x(ind1(i)),x(ind2(i))],...
                    [y(ind1(i)),y(ind2(i))],...
                    'Color',colVal,...
                    'LineWidth',lineWdt);
                end
                %abs(adjacencyMatrix(ind1(i),ind2(i))));
            end
            
            % set colormap to show on figure according to the 
            % max and min values given
            if this.ShowColorbar
                colormap(rbw_cmap)
                hCB = colorbar('eastoutside');
                hCB.Position = [0.125 0.05 0.75 0.03];
                hCB.Location = 'eastoutside';% TEMP - originally'eastoutside';
                hCB.Limits = [this.MinVal this.MaxVal];
                set(hCB, 'Position', [0.95, 0.2, 0.02, 0.6]);
                caxis([this.MinVal this.MaxVal]);
            end
            axis equal off
        end
    end
end
