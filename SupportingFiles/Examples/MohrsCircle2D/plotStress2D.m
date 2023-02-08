function [sigman, taun] = plotStress2D(thetad,sigmax,sigmay,tauxy)
    
    % Calculations
    % Normal stress/normal shear in the plane
    sigman = 0.5*(sigmax + sigmay) + 0.5*(sigmax - sigmay)*cosd(2*thetad) ...
             + tauxy*sind(2*thetad);
    taun = -0.5*(sigmax - sigmay)*sind(2*thetad) + tauxy*cosd(2*thetad);

    % Plot parameters and definitions
    rs = 0.5; % Half square side
    rp = 0.9; % Radius of plane circle
    rtheta = rp/4; % Theta annotation radius
    sc = 0.045; % Scale factor for stress arrows
    arrlw = 1.5; % Arrow line width
    headSize = 0.15;
    axLims = [-1.1 1 -1 1];
    % Colors
    thetaAnnotationColor = [0 0.447 0.741];
    quiverColorF = [186 30 9]/255;
    quiverColorR = [186 30 9]/255;%[133 15 0]/255;
    quiverColorN = [235 138 40]/255;% [210 24 0]/255;
    planeColor = [1 1 1]*0.925;
    
    % Theta annotation
    thd = linspace(0,thetad,abs(thetad)*2);
    x_angleAnnotation = [1.2*rtheta,0,0.7*rtheta*cosd(thd)];
    y_angleAnnotation = [0,0,0.7*rtheta*sind(thd)];
    nsc = [1.25*rtheta*cosd(thetad),1.25*rtheta*sind(thetad)];

    % Stress vectors
    n = [cosd(thetad), sind(thetad)];
    xr = [-rs, 0, -rs, 0]';
    yr = [0, -rs, 0, -rs]';
    xf = [rs, 0, rs, 0]';
    yf = [0, rs, 0, rs]';
    ur = sc*[-sigmax, 0, 0, -tauxy]';
    vr = sc*[0, -sigmay, -tauxy, 0]';
    uf = sc*[sigmax, 0, 0, tauxy]';
    vf = sc*[0, sigmay, tauxy, 0]';
    xn = [0 0];
    yn = [0 0];
    un = sc*[n(1)*sigman -n(2)*taun];
    vn = sc*[n(2)*sigman n(1)*taun];
    
    % Create plot
    cla
    set(gca,"Clipping","off")
    patch([-1 1 1 -1]*rs,[-1 -1 1 1]*rs,planeColor) % Element square patch
    hold on
    plot([-1,1]*rp*cosd(thetad+90),[-1,1]*rp*sind(thetad+90),"k","LineWidth",0.85) % Cutting line

    % Theta annotation with lines
    plot(x_angleAnnotation,y_angleAnnotation,...
        "Color",thetaAnnotationColor,"LineWidth",0.85)
    quiver(0,0,nsc(1),nsc(2),"Color",thetaAnnotationColor,"LineWidth",0.85,"AutoScale","off")
    text(rtheta*cosd(thetad/2),rtheta*sind(thetad/2),...
        "\theta","Color",thetaAnnotationColor,"HorizontalAlignment","center")
    text(nsc(1)*1.2,nsc(2)*1.2,"n","Color",thetaAnnotationColor,...
        "VerticalAlignment","middle","HorizontalAlignment","center")
        
    % Stress arrows
    quiver(xr,yr,ur,vr,"Autoscale","off","Color",quiverColorR,...
        "LineWidth",arrlw,"MaxHeadSize",headSize)
    quiver(xf,yf,uf,vf,"Autoscale","off","Color",quiverColorF,...
        "LineWidth",arrlw,"MaxHeadSize",headSize)
    quiver(xn,yn,un,vn,"Autoscale","off","Color",quiverColorN,...
        "LineWidth",arrlw,"MaxHeadSize",headSize)
    hold off

    % Normal stress labels
%     text(xn(1)+un(1)*1.3,yn(1)+vn(1)*1.2,"|\sigma_n|=" + num2str(sigman,2),...
%         "HorizontalAlignment","left")
%     text(xn(2)+un(2)*1.3,yn(2)+vn(2)*1.2,"|\tau_n|=" + num2str(taun,2),...
%         "HorizontalAlignment","left")
    text(-rs,rs + 0.5,"|\sigma_n| = " + num2str(sigman,2) + "     |\tau_n| = " + num2str(taun,2),...
        "HorizontalAlignment","left")

    % Axis settings
    axis equal
    axis(axLims)
    axis off

end