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
% ShowColorbar: Boolean value that indicates whether to show the colorbar
%%
% Author: Jan-Luca Schröder

    properties
%         Node = node(0,0); % Array of nodes
        Label;            % Cell array of strings
        MaxVal;           % Numeric value
        MinVal;           % Numeric value
        ShowColorbar;     % Boolean value
        TextSize;         % Numeric value
        MaxLineThickness; % Numeric value  
    end

    methods
        function this = connCirclePlot(adjacencyMatrix,varargin)

            p = inputParser;

            % Daniel's r-b-w colormap:
            load('/mnt/storage/tier2/danbal/BRACHR002N3B/Luca/MyColormaps', 'rbw_db2');
            
            % set default label
            defaultLabel = cell(length(adjacencyMatrix),1);
            for i = 1:length(defaultLabel)
                defaultLabel{i} = num2str(i);
            end

            % turn on colorbar by default
            defaultShowColorbar = true;

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

            parse(p,adjacencyMatrix,varargin{:});

            this.Label      = p.Results.Label;
            this.MinVal     = p.Results.MinVal;
            this.MaxVal     = p.Results.MaxVal;
            this.TextSize   = p.Results.TextSize;
            this.ShowColorbar     = p.Results.ShowColorbar;
            this.MaxLineThickness = p.Results.MaxLineThickness;

            theta=linspace(0,2*pi,length(adjacencyMatrix)+1);
            theta=theta(1:end-1);
            [x,y]=pol2cart(theta,1);

            % links=triu(round(rand(length(theta)))); % this is a random list of connections
            [ind1,ind2]=ind2sub(size(adjacencyMatrix),find(adjacencyMatrix(:)));

       
            % [minDistance, indexOfMin] = min(abs(colourmap-adjacencyMatrix(1,3)));
            
            % plot nodes
%             h=figure;
%             clf(h);
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
                colVal = rbw_db2(indexOfMin,:);
                % set linewidth based on limits
                lineWdt = lineWidthBar(indexOfMin);
                % draw a line
%                 disp([cos(x(ind1(i))),sin(x(ind2(i)))])
                line([x(ind1(i)),x(ind2(i))],...
                    [y(ind1(i)),y(ind2(i))],...
                    'Color',colVal,...
                    'LineWidth',lineWdt);
                %abs(adjacencyMatrix(ind1(i),ind2(i))));
            end
            
            % set colormap to show on figure according to the 
            % max and min values given
            if this.ShowColorbar
                colormap(rbw_db2)
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