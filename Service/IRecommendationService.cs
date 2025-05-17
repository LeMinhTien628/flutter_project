namespace api_app_pizza_flutter.Service
{
    public interface IRecommendationService
    {
        List<int> Recommend(int productId, int topN = 5);
    }
}
