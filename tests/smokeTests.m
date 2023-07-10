% Run these tests with runMyTests
% All tests so far are on code expected to run without errors
% If/when we end up with a version that _should_ error, 
% please add it to this set of examples
classdef smokeTests < matlab.unittest.TestCase

    properties
        fc
        origProj
        openFilesIdx
    end

    methods (TestClassSetup)
        function setUpPath(testCase)
            testCase.origProj = matlab.project.rootProject;
            testCase.openFilesIdx = length(matlab.desktop.editor.getAll);

            testCase.fc = fullfile(pwd);
            rootDirName = extractBefore(testCase.fc,"tests");
            openProject(rootDirName);
        end % function setUpPath
    end % methods (TestClassSetup)

    methods(Test)

        function testMLX(testCase)
            % this functions opens and closes all the the .mlx files located under the
            % project rootFolder and its subfolder, it is intended to
            % detect corrupted files
            files = dir(testCase.origProj.RootFolder+filesep+"**"+filesep+"*.mlx");
            for i = 1:size(files)
                f = string(files(i).folder)+filesep+string(files(i).name);
                f = matlab.desktop.editor.openDocument(f);
                f.closeNoPrompt;
            end
        end
        
        function testMAT(testCase)
            % this functions opens and closes all the the .mat files located under the
            % project rootFolder and its subfolder, it is intended to
            % detect corrupted data 
            files = dir(testCase.origProj.RootFolder+filesep+"**"+filesep+"*.mat");
            for i = 1:size(files)
                f = string(files(i).folder)+filesep+string(files(i).name);
                f = open(f); %#ok<NASGU>
                clear f
            end
        end

        function testSLX(testCase)
            % this functions opens and closes all the the .slx files located under the
            % project rootFolder and its subfolder, it is intended to
            % detect corrupted simulink model
            files = dir(testCase.origProj.RootFolder+filesep+"**"+filesep+"*.slx");
            for i = 1:size(files)
                f = string(files(i).folder)+filesep+string(files(i).name);
                open_system(f)
                close_system(f)
            end
        end

        function runBeamBending(testCase)
            % this is the simplest possible logged version of a smoke test
            % that will run a file called "SharingCode.mlx"
            disp("Running Part 1...")
            Part1_BeamBending
            disp("Finished with Part 1")
        end

        function runBeamDeflection(testCase)
            % this is the simplest possible logged version of a smoke test
            % that will run a file called "SharingCode.mlx"
            disp("Running Part 2...")
            Part2_BeamDeflection
            disp("Finished with Part 2")
        end
    end

    methods (TestClassTeardown)
        function resetPath(testCase)

            if isempty(testCase.origProj)
                close(currentProject)
            else
                openProject(testCase.origProj.RootFolder)
            end
            myLastList = matlab.desktop.editor.getAll;
            if length(myLastList)>testCase.openFilesIdx
                closeNoPrompt(myLastList(testCase.openFilesIdx+1:end))
            end
            cd(testCase.fc)
            close all force
        end

    end % methods (TestClassTeardown)

end