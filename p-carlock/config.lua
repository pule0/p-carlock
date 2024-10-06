P = {}

P.NotificationType = 'esx'
P.LockDuration = 2000
P.HornSound = 'HELDDOWN' 
P.LightFlash = true 
P.Horns = true

P.TargetIcon = "fas fa-key" -- fontawesome icons only


P.Locales = {
    carlock = "Carlock", -- text for the target
    lockMessage = 'Vehicle Locked',
    unlockMessage = 'Vehicle Unlocked',
    notOwnedMessage = 'This vehicle is not owned by you!',
    lockingLabel = 'Locking/Unlocking Vehicle',
    vehicleNotClose = 'You must be near the vehicle to lock/unlock it!'
}

-- Animation settings
P.Animation = {
    dict = 'anim@mp_player_intmenu@key_fob@',
    clip = 'fob_click',
    duration = 1000
}



-- ProgressBar settings
P.ProgressBar = {
    duration = 1000,
    label = P.Locales.lockingLabel -- already defined up in Locales, row 17
}
