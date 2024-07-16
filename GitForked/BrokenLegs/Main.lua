-- BrokenLegs (Main.lua)

-- Turbine imports
import "Turbine";
import "Turbine.Gameplay";

EffectList = Turbine.Gameplay.LocalPlayer:GetInstance():GetEffects();

local broken_legs = 0

function CheckBrokenLegs()
    for i = 1, EffectList:GetCount(), 1 do
        if (EffectList:Get(i):GetName()) == "Falling Injuries"
        then
            broken_legs = broken_legs + 1
            Turbine.Shell.WriteLine("Broken legs this session: " .. broken_legs)
            break
        end
    end
end

function CheckBrokenLegsVerbose()
    for i = 1, EffectList:GetCount(), 1 do
        --if (EffectList:Contains("Falling Injuries") == true)  -- This line did NOT work, even though the LOTRO API lists it as valid. Using a custom work-around below.
        if (EffectList:Get(i):GetName()) == "Falling Injuries"
        then
            Turbine.Shell.WriteLine("Falling Injuries effect is active, you broke a leg.")
        else
            Turbine.Shell.WriteLine(EffectList:Get(i):GetName() .. " is not Falling Injuries.")
        end
    end
end

function ListAllEffects()
    for i = 1, EffectList:GetCount(), 1 do
        Turbine.Shell.WriteLine(EffectList:Get(i):GetName());
    end
end

--Callback Handler - Pengoros Method
function AddCallback(object, event, callback)
    if (object[event] == nil) then
        object[event] = callback;
    else
        if (type(object[event]) == "table") then
            table.insert(object[event], callback);
        else
            object[event] = {object[event], callback};
        end
    end
    return callback;
end

-- BrokenLegs Commands
BrokenLegsCommand = Turbine.ShellCommand();

function BrokenLegsCommand:Execute(command, arguments)
    if (arguments == "1") then
        --Turbine.Shell.WriteLine("BrokenLegs: Check For Broken Legs.");
        CheckBrokenLegs();
    end
    if (arguments == "2") then
        Turbine.Shell.WriteLine("BrokenLegs: Check For Broken Legs (verbose).");
        CheckBrokenLegsVerbose();
    end
    if (arguments == "3") then
        Turbine.Shell.WriteLine("BrokenLegs: List All Effects.");
        ListAllEffects();
    end
end

Turbine.Shell.AddCommand("BrokenLegs;brokenlegs;BL;bl", BrokenLegsCommand);

-- Effect Callback
AddCallback(EffectList, "EffectAdded", CheckBrokenLegs);

-- Plugin Loaded Message
Turbine.Shell.WriteLine("<rgb=#008080>BrokenLegs</rgb> " .. Plugins.BrokenLegs:GetVersion() .. " by <rgb=#008080>Git-Forked</rgb> loaded.");
