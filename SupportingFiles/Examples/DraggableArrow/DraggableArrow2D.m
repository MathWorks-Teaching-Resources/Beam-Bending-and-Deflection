classdef DraggableArrow2D
    %DRAGGABLEARROW2D 
    % Creates an arrow that can be interactively extended or shortened
    % by clicking and dragging on the object in the figure window
    %
    % Constructor syntax:
    %    DraggableArrow2D(x,y,u,v,mode)
    %    DraggableArrow2D(ax,x,y,u,v,mode)
    %    DraggableArrow2D(ax,x,y,u,v,mode,moveFuncHandle)
    %    DraggableArrow2D(ax,x,y,u,v,mode,moveFuncHandle,completeFuncHandle)
    %
    % The mode should be set to "all" (rotation and magnitude)
    %                        or "mag" (only magnitude)
    % The function handle takes one input argument: this quiver object
    
    properties
        
        % Settings
        lw = 1.5; % Default linewidth
        lwSelectMult = 1.5; % Selected linewidth
        selectColor = [0.8, 0.8, 0];
        % if mode is set to mag, it only moves in one direction
        % otherwise, it will move in any direction 
        mode = "mag";

        % Objects
        quiverHandle
        moveFuncHandle = []; % Function to be executed during move
        completeFuncHandle = []; % Function to be executed at release
    end
    
    methods
        function obj = DraggableArrow2D(in1,in2,in3,in4,in5,in6,in7,in8)
            if nargin == 5
                obj.quiverHandle = quiver(gca,in1,in2,in3,in4,"linewidth",obj.lw);
                obj.mode = in5;
            elseif nargin == 6
                obj.quiverHandle = quiver(in1,in2,in3,in4,in5,"linewidth",obj.lw);
                obj.mode = in6;
            elseif nargin == 7
                obj.quiverHandle = quiver(in1,in2,in3,in4,in5,"linewidth",obj.lw);
                obj.mode = in6;
                obj.moveFuncHandle = in7;
            elseif nargin == 8
                obj.quiverHandle = quiver(in1,in2,in3,in4,in5,"linewidth",obj.lw);
                obj.mode = in6;
                obj.moveFuncHandle = in7;
                obj.completeFuncHandle = in8;
            else
                error("DraggableArrow2d expects 5-8 input arguments.")
            end

            % Set the callback 
            obj.quiverHandle.ButtonDownFcn = @obj.resizeQuiver;
        end
        
        function resizeQuiver(obj,src,event)

            % Temporarily set the axis mode to manual
            origModes = {obj.quiverHandle.Parent.XLimMode, obj.quiverHandle.Parent.YLimMode};
            obj.quiverHandle.Parent.XLimMode = "manual";
            obj.quiverHandle.Parent.YLimMode = "manual";
            origlw = obj.quiverHandle.LineWidth;
            obj.quiverHandle.LineWidth = obj.lwSelectMult*origlw;
            origColor = obj.quiverHandle.Color;
            obj.quiverHandle.Color = (obj.selectColor + origColor)/2;
            
            % Handle clicks on the plot objects
            set(gcbf,"WindowButtonMotionFcn",{@obj.mouseMove,src})
            set(gcbf,"WindowButtonUpFcn",{@obj.mouseRelease,src,origModes,origlw,origColor})     
        end

         % Moves an object around the plot (used to move the poles/zeros)
        function mouseMove(obj,src,event,plotSrc)
            % Get the current point
            currentPoint = plotSrc.Parent.CurrentPoint;
            x = currentPoint(1,1);
            y = currentPoint(1,2);

            % Compute the new location of u,v
            xy0 = [obj.quiverHandle.XData; obj.quiverHandle.YData];
            uv0 = [obj.quiverHandle.UData; obj.quiverHandle.VData];

            % Compute the projection
            what = [x-xy0(1); y-xy0(2)];
           
            if(strcmp(obj.mode,"mag"))
                uproj = dot(what,uv0)/dot(uv0,uv0)*uv0;
                % Update u,v based on the projection
                obj.quiverHandle.UData = uproj(1);
                obj.quiverHandle.VData = uproj(2);
            else
                obj.quiverHandle.UData = what(1);
                obj.quiverHandle.VData = what(2);

            end
   
            % Execute the function handle
            if(~isempty(obj.moveFuncHandle))
                obj.moveFuncHandle(obj)
            end

            % This gives time for the graph to update and is faster than
            % drawnow, because it doesn't update the UI, only the plot
            pause(0)
        end
        
        % Stop moving the object around
        function mouseRelease(obj,src,event,plotSrc,origModes,origlw,origColor)
            obj.mouseMove(src,event,plotSrc);
            % remove the callbacks and unselect
            set(gcbf,"WindowButtonMotionFcn","")
            set(gcbf,"WindowButtonUpFcn","")

            % Restore values
            obj.quiverHandle.Parent.XLimMode = origModes{1};
            obj.quiverHandle.Parent.YLimMode = origModes{2};
            obj.quiverHandle.LineWidth = origlw;
            obj.quiverHandle.Color = origColor;

            % Execute the function handle
            if(~isempty(obj.completeFuncHandle))
                obj.completeFuncHandle(obj)
            end

            % Update the plot/UI
            drawnow
        end
    end

end

