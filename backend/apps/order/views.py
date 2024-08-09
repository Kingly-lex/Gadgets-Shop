from rest_framework.generics import GenericAPIView, ListAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status

# local
from .serializers import PlaceOrderSerializer, ViewOrdersSerializer
from .models import Order


class PlaceOrderView(GenericAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = PlaceOrderSerializer

    def post(self, request):
        serializer = self.serializer_class(data=request.data, context={'request': request})
        if serializer.is_valid(raise_exception=True):
            return Response(
                {
                    'response': "Order has been placed successfully",
                    'data': serializer.data,
                }, status=status.HTTP_201_CREATED)
        return Response({"response": "Something Went Wrong"}, status=status.HTTP_400_BAD_REQUEST)


class ViewOrders(ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = ViewOrdersSerializer

    def get_queryset(self):
        return Order.objects.filter(user=self.request.user).order_by('-created_at')
