-- ESP display names.
-- ["name the game uses"] = "name the ESP shows"
-- Set a name to false to never show it on the ESP.
--
-- Trailing numbers and the leading dot are ignored when matching, so one line covers every copy:
--   [".MobName"] = "Mob"   matches  .MobName124, .MobName125, MobName7, ...
-- An exact entry (".MobName124") wins over the general one.
return {
    -- Loot
    ["BigArtifact"] = "Artifact",

    -- Mobs / NPCs
    [".training_dummy"] = "Training Dummy",
}
