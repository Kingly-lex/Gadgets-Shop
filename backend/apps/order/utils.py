from django.core.mail import EmailMessage
from django.conf import settings


def send_placed_order_notification(order, user):

    order_details = f'''Quantity: {order.quantity}\n
    Amount: {order.total_amount}\n
    Payment method: {order.payment_method}\n
    Status: {order.status}\n
    Created at: {order.created_at}'''

    body = f'You have Successfully Placed an Order with us, here are Your order details:\n{order_details}'
    mail = EmailMessage(
        from_email=settings.DEFAULT_FROM_EMAIL,
        subject="Placed Order Notification",
        body=body,
        to=[user.email]
    )

    mail.send(fail_silently=True)
