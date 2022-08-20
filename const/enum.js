const accountTypes = ["customer", "merchant", "rider", "organizer"];
const checkoutStatus = ["to-pack", "packed", "to-deliver", "delivered"];
const riderStatus = ["active", "inactive"];
const messageTypes = ["billing", "message", "news"];
const userRoles = ["customer", "planner", "organizer"];
const eventTypes = ["wedding", "kids-birthday-party", "adults-birthday-party", "disco", "casual-party"];
const eventStatus = ["preparing", "in-progress", "completed", "cancelled"];
const paymentType = ["card", "cash"];
const paymentStatus = ["unpaid", "paid"];

module.exports = {
    accountTypes,
    checkoutStatus,
    riderStatus,
    messageTypes,
    userRoles,
    eventTypes,
    eventStatus,
    paymentType,
    paymentStatus
};
