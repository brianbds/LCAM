% Create UIFigure and hide until all components are created
            UIFigure = uifigure('Visible', 'off');
            UIFigure.Position = [100 100 1053 627];
            UIFigure.Name = 'Reflectance Plots';

            % Create Reflectance_decay
            Reflectance_decay = uiaxes(UIFigure);
            title(Reflectance_decay, 'Reflectance in decay phase')
            xlabel(Reflectance_decay, 'Wavelength [nm]')
            ylabel(Reflectance_decay, 'Reflectance [%]')
            Reflectance_decay.Position = [28 309 500 300];

            % Create Reflectance_exposure
            Reflectance_exposure = uiaxes(UIFigure);
            title(Reflectance_exposure, 'Reflectance in exposure phase')
            xlabel(Reflectance_exposure, 'Wavelength [nm]')
            ylabel(Reflectance_exposure, 'Reflectance [%]')
            Reflectance_exposure.Position = [527 309 500 300];

            % Create Reflectance_time
            Reflectance_time = uiaxes(UIFigure);
            title(Reflectance_time, 'Reflectance in time')
            xlabel(Reflectance_time, 'Time [s]')
            ylabel(Reflectance_time, 'Reflectance [%]')
            Reflectance_time.Position = [27 10 1000 300];

            % Show the figure after all components are created
            UIFigure.Visible = 'on';