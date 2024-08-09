from rest_framework.response import Response
from rest_framework import status
from rest_framework.generics import GenericAPIView, RetrieveAPIView
from rest_framework.permissions import IsAuthenticated


# local
from .serializers import RetrieveProfileSerializer, UpdateProfileSerializer
from .models import Profile, DeliveryAddress


class ViewProfile(RetrieveAPIView):
    serializer_class = RetrieveProfileSerializer
    permission_classes = [IsAuthenticated]

    def get_object(self):
        profile = Profile.objects.get(user=self.request.user)
        return profile


class UpdateProfile(GenericAPIView):
    serializer_class = UpdateProfileSerializer
    permission_classes = [IsAuthenticated]

    def patch(self, request):
        profile = Profile.objects.get(user=request.user)
        first_name = request.data.get('first_name', None)
        last_name = request.data.get('last_name', None)
        delivery_addresses = request.data.get('delivery_addresses', None)

        if first_name is not None:
            first_name = request.data.pop('first_name')
        if last_name is not None:
            last_name = request.data.pop('last_name')
        if delivery_addresses is not None:
            delivery_addresses = request.data.pop('delivery_addresses')

        serializer = self.serializer_class(instance=profile, data=request.data,
                                           context={'request': request}, partial=True)
        if serializer.is_valid(raise_exception=True):
            user = request.user
            if first_name is not None:
                user.first_name = first_name
            if last_name is not None:
                user.last_name = last_name
            if delivery_addresses is not None:

                try:
                    for address in delivery_addresses:
                        apt_no = address.get('apt_no', None)
                        additional_info = address.get('additional_info', None)

                        new = DeliveryAddress()
                        new.profile = profile
                        new.apt_no = apt_no
                        new.address = address['address']
                        new.additional_info = additional_info
                        new.city = address['city']
                        new.region = address['region']
                        new.save()
                except Exception as e:
                    return Response({'response': str(e)}, status=status.HTTP_406_NOT_ACCEPTABLE)

            user.save()
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
