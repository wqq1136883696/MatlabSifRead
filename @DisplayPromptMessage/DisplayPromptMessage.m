classdef DisplayPromptMessage < matlab.apps.AppBase
    %DisplayPromptMessage 此处显示有关此类的摘要
    %   此处显示详细说明 

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure  
        Panel     matlab.ui.container.Panel
        OKButton  matlab.ui.control.Button
        Label     matlab.ui.control.Label
        title               % 标题
        displayMessage      % 显示内容
    end

    methods (Access = private)

        % Button pushed function: OKButton
        function OKButtonPushed(app, ~)
            delete(app.Panel);
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create Panel
            app.Panel = uipanel(app.UIFigure);
            app.Panel.Title = app.title;
            app.Panel.FontSize = 16;
            app.Panel.Position = [500 300 404 178];

            % Create OKButton
            app.OKButton = uibutton(app.Panel, 'push');
            app.OKButton.ButtonPushedFcn = createCallbackFcn(app, @OKButtonPushed, true);
            app.OKButton.FontSize = 16;
            app.OKButton.Position = [338 13 44 26];
            app.OKButton.Text = 'OK';

            % Create Label
            app.Label = uilabel(app.Panel);
            app.Label.HorizontalAlignment = 'center';
            app.Label.FontSize = 16;
            app.Label.Position = [54 38 285 105];
            app.Label.Text = app.displayMessage;
        end
    end

    methods (Access = public)

        % Construct app
        function app = DisplayPromptMessage(uifigure,title,displayMessage)
            app.UIFigure = uifigure;
            app.displayMessage = displayMessage;
            app.title = title;
            % Create and configure components
            createComponents(app)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.Panel)
        end
    end
end